{ config, pkgs, pkgsUnstable, inputs, ... }:
let
  flakePackages = builtins.mapAttrs (
    name: value: value.packages.${pkgs.system}.default) {
      inherit (inputs)
      json2nix; };

  pinnedHugo = import inputs.pinned-hugo {
    inherit (pkgs.stdenv.hostPlatform) system;
    inherit (config.nixpkgs) config;
  };

  # Rust 1.93 toolchain for hazelnut
  rustToolchain = pkgs.rust-bin.stable.latest.default.override {
    extensions = [ "rust-src" ];
  };

  hazelnut = import ../../pkgs/rust/hazelnut {
    inherit pkgs rustToolchain;
  };

  rtk = import ../../pkgs/rust/rtk {
    inherit pkgs rustToolchain;
    src = inputs.rtk-src;
  };

  bun = import ../../pkgs/bun { inherit pkgs; };

  btca = import ../../pkgs/btca { inherit pkgs bun; src = inputs.btca-src; };

  opencode = import ../../pkgs/opencode { inherit pkgs pkgsUnstable bun; };

  openwork = import ../../pkgs/openwork { inherit pkgs opencode; };

in

{
  # from: https://discourse.nixos.org/t/mixing-stable-and-unstable-packages-on-flake-based-nixos-system/50351/4
  # this allows you to access `pkgsUnstable` anywhere in your config
  _module.args.pkgsUnstable = import inputs.nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;
    inherit (config.nixpkgs) config;
  };

  # nixpkgs.config.allowUnfree = true;
  # set comma to use prebuilt nixpkgs database from inputs
	programs.nix-index-database.comma.enable = true;
  environment.systemPackages = with pkgs; [
    git
    git-crypt
    ffmpeg-full
    zfs_2_3
    htop
    gotop
    btop-rocm # TODO: configure for smaller screen: https://github.com/aristocratos/btop?tab=readme-ov-file#configurability
    powershell
    mediainfo
    aria2
    nh # https://github.com/nix-community/nh
    comma
    tealdeer
    rclone
    #lima
    gcc # needed for test nvim configs
    pkgsUnstable.neovim
    wget
    cfssl # copyparty dependency
    usbutils
    sqlite
    forgejo-cli
    ansible
    sshpass # needed for ansible
    auto-editor
    pipx
    atomicparsley
    lsof
    unrar
    opencode
    openwork

    # custom rust packages
    hazelnut
    rtk

    # custom packages
    bun
    btca

    # python packages
    (python3.withPackages (python-pkgs: with python-pkgs; [
      eyed3
    ]))

    # gui programs
    calibre
    smplayer
    tageditor
    vlc
    bitwarden-desktop
    picard

    # KDE apps
    kdePackages.partitionmanager # kparted
    kdePackages.k3b # cd/dvd tool
    kdePackages.kdenlive
  ]
  ++ (import ../common/packages.nix { pkgs = pkgs; })
  ++ pkgs.lib.attrValues flakePackages;
}

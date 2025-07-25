{ config, lib, pkgs, inputs, pkgsUnstable, secrets, ... }:
{
    # from: https://discourse.nixos.org/t/mixing-stable-and-unstable-packages-on-flake-based-nixos-system/50351/4
    # this allows you to access `pkgsUnstable` anywhere in your config
    _module.args.pkgsUnstable = import inputs.nixpkgs-unstable {
      inherit (pkgs.stdenv.hostPlatform) system;
      inherit (config.nixpkgs) config;
    };

    # set comma to use prebuilt nixpkgs database from inputs
	  programs.nix-index-database.comma.enable = true;
    environment.systemPackages = with pkgs; [
      git
      git-crypt
      profile-sync-daemon
      rpi-imager
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
      pkgsUnstable.neovim
      buku

      # GUI
      calibre
      obs-studio

      # KDE apps
      kdePackages.krdc # remote desktop client
      kdePackages.partitionmanager # kparted

      # python packages
      (python3.withPackages (python-pkgs: with python-pkgs; [
        requests
        jinja2
      ]))

      # ruby packages
      (ruby.withPackages (ruby-pkgs: with ruby-pkgs; [
        pry
        dotenv
      ]))
    ]++ (import ../../common/packages.nix { pkgs = pkgs; });
}

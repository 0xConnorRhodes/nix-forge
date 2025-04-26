{ config, lib, pkgs, inputs, pkgsUnstable, secrets, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./gnome.nix
      ./ssh-mosh.nix
      ./secret.nix
      #./kiosk.nix
      ../../common/nixos-common.nix
      ../../common/nixos-packages.nix
      ../../common/gnome-common.nix
      ../../../modules/nixos/kvm.nix
      ../../../modules/nixos/incus.nix
      ../../../modules/nixos/tailscale.nix
      ../../../modules/nixos/sync-notes.nix
      inputs.home-manager.nixosModules.default
      inputs.nix-index-database.nixosModules.nix-index
    ];

  options = {
    myConfig = {
      username = lib.mkOption { type = lib.types.str; default = "connor";};
    };
  };

  config = {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    
    # zfs
    boot.kernelPackages = pkgs.pkgs.linuxPackages_xanmod; # xanmod LTS kernel
    boot.supportedFilesystems = [ "zfs" ];
    networking.hostId = "4539c42d"; # needed by zfs to track unique machines for pool import

    networking.hostName = "latitude";
    networking.networkmanager.enable = true;

    time.timeZone = "America/Chicago";

    programs.zsh = {
      enable = true;
    };

    users.users.${config.myConfig.username} = {
      isNormalUser = true;
      description = "Connor Rhodes";
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.zsh;
      openssh = {
        authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAHczZo2Xoo9jN7BGmtu2nabaSzFq9sW2Y4eh7UELReA connor@devct"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILvE1Dk8jXCzFOqyph0k8Lp/ynYMX5vqA/MZni2L/JE4 connor@rhodes.contact"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHDPTeOGdCMgihUyRXEmpFdJeFSKoB6VGSou13+f8dI6 u0_a301@localhost" # termux
        ];
      };
    };

    home-manager.backupFileExtension = "bak"; # append existing non hm files with this on rebuild
    home-manager.users.${config.myConfig.username} = { pkgs, ... }: {
      home.stateVersion = "24.11";
      imports = [
        ./home.nix
        ../../common/gnome-dconf-common.nix
      ]; 
    };

    # services
    services.printing.enable = true;
    services.psd.enable = true;
    programs.firefox.enable = true;

    # from: https://discourse.nixos.org/t/mixing-stable-and-unstable-packages-on-flake-based-nixos-system/50351/4
    # this allows you to access `pkgsUnstable` anywhere in your config
    _module.args.pkgsUnstable = import inputs.nixpkgs-unstable {
      inherit (pkgs.stdenv.hostPlatform) system;
      inherit (config.nixpkgs) config;
    };

    nixpkgs.config.allowUnfree = true;
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

    # prevent password prompt on opening vscode
    security.pam.services.gdm-password.enableGnomeKeyring = true;

    # subsystems
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
    };

    system.stateVersion = "24.11";
  };
}

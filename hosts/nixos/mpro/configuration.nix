{ config, lib, pkgs, inputs, pkgsUnstable, secrets, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./gnome.nix
      ./mounts.nix
      ./secret.nix
      ./backup-cron.nix
      ./syncthing.nix
      ../../common/nixos-common.nix
      ../../common/nixos-packages.nix
      ../../common/gnome-common.nix
      ../../../modules/nixos/kvm.nix
      ../../../modules/nixos/incus.nix
      ../../../modules/nixos/tailscale.nix
      ../../../modules/nixos/sync-notes.nix
      ../../../modules/nixos/jellyfin.nix
      ../../../modules/nixos/zk-cron.nix
      inputs.home-manager.nixosModules.default
      inputs.nix-index-database.nixosModules.nix-index
    ];

  options = {
    myConfig = {
      username = lib.mkOption { type = lib.types.str; default = "connor";};
      hostname = lib.mkOption { type = lib.types.str; default = "mpro";};
      homeDir = lib.mkOption { type = lib.types.str; default = "/home/connor";};
      tailscaleIp = lib.mkOption { type = lib.types.str; default = "127.0.0.1";};
    };
  };

  config = {

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # zfs
    boot.kernelPackages = pkgs.pkgs.linuxPackages_xanmod; # xanmod LTS kernel
    boot.supportedFilesystems = [ "zfs" ];
    networking.hostId = "eca3fb4d";

    # Networking
    myConfig.tailscaleIp = "100.80.72.12";
    networking = {
      hostName = config.myConfig.hostname;
      useDHCP = false;
      networkmanager.enable = true;

      interfaces.enp9s0.ipv4.addresses = [{
        address = "192.168.86.11";
        prefixLength = 24;
      }];

      defaultGateway = "192.168.86.1";
      nameservers = [ "1.1.1.1" "1.0.0.1" ];
    };
    networking.firewall.enable = true;

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
    nixpkgs.config.allowUnfree = true;
    home-manager.users.${config.myConfig.username} = { pkgs, ... }: {
      home.stateVersion = "24.11";
      imports = [
        ./home.nix
        ./gnome-dconf.nix
        ./gnome-always-on.nix
        ../../common/gnome-dconf-common.nix
      ]; 
    };

    # suspend
    services.xserver.displayManager.gdm.autoSuspend = false;
    services.logind.extraConfig = ''
      HandleLidSwitchExternalPower=ignore
    '';

    # services
    programs.mosh.enable = true;
    services.openssh = {
      enable = true;
      ports = [ 31583 ];
      settings.PasswordAuthentication = false;
    };

    #services.flatpak.enable = true;
    services.printing.enable = true;
    services.psd.enable = true;
    programs.firefox.enable = true;

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
      profile-sync-daemon
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

      # gui programs
      calibre

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

    # subsystems
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
    };

    system.stateVersion = "24.11";
  };
}

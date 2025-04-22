{ config, lib, pkgs, inputs, pkgsUnstable, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./gnome.nix
      ./secret.nix
      #./kiosk.nix
      ../../common/packages.nix
      ../../common/nixos-common.nix
      ../../common/nixos-packages.nix
      ../../common/gnome-common.nix
      ../../../modules/nixos/kvm.nix
      ../../../modules/nixos/incus.nix
      ../../../modules/nixos/sync-notes.nix
      inputs.home-manager.nixosModules.default
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

    users.users.${config.myConfig.username} = {
      isNormalUser = true;
      description = "Connor Rhodes";
      extraGroups = [ "networkmanager" "wheel" ];
    };

    home-manager.users.${config.myConfig.username} = { pkgs, ... }: {
      home.stateVersion = "24.11";
      imports = [
        ./home.nix
        ../../common/gnome-dconf-common.nix
      ]; 
    };

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
    environment.systemPackages = with pkgs; [
      profile-sync-daemon
      rpi-imager
      ffmpeg-full
      zfs_2_3
    ];

    # subsystems
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
    };

    system.stateVersion = "24.11";
  };
}

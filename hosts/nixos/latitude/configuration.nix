{ config, lib, pkgs, inputs, pkgsUnstable, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./gnome.nix
      #./kiosk.nix
      ../../common/packages.nix
      ../../common/nixos-common.nix
      ../../common/nixos-packages.nix
      ../../../modules/nixos/incus.nix
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

    networking.hostName = "latitude";
    networking.networkmanager.enable = true;

    time.timeZone = "America/Chicago";

    services.printing.enable = true;

    users.users.${config.myConfig.username} = {
      isNormalUser = true;
      description = "Connor Rhodes";
      extraGroups = [ "networkmanager" "wheel" ];
    };

  home-manager.users.${config.myConfig.username} = { pkgs, ... }: {
    home.stateVersion = "24.11";
    imports = [
      ./home.nix
      ../../common/gnome-common.nix
    ]; 
  };

    programs.firefox.enable = true;

    # from: https://discourse.nixos.org/t/mixing-stable-and-unstable-packages-on-flake-based-nixos-system/50351/4
    # this allows you to access `pkgsUnstable` anywhere in your config
    _module.args.pkgsUnstable = import inputs.nixpkgs-unstable {
      inherit (pkgs.stdenv.hostPlatform) system;
      inherit (config.nixpkgs) config;
    };

    nixpkgs.config.allowUnfree = true;
    environment.systemPackages = with pkgs; [
      rpi-imager
    ];

    system.stateVersion = "24.11";
  };
}

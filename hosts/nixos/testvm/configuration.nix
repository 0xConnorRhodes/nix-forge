{ config, lib, pkgs, inputs, pkgsUnstable, ... }:

{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ../../common/nixos-common.nix
      ../../common/gnome-common.nix
      ../../common/packages.nix
    ];

  options = {
    myConfig = {
      username = lib.mkOption { type = lib.types.str; default = "connor";};
    };
  };

  config = {
    # Bootloader.
    boot.loader.grub.enable = true;
    boot.loader.grub.device = "/dev/vda";
    boot.loader.grub.useOSProber = true;

    networking.hostName = "testvm"; # Define your hostname.
    networking.networkmanager.enable = true;

    time.timeZone = "America/Chicago";


    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.${config.myConfig.username} = {
      isNormalUser = true;
      description = "Connor Rhodes";
      extraGroups = [ "networkmanager" "wheel" ];
    };

    home-manager.users.${config.myConfig.username} = { pkgs, ... }: {
      home.stateVersion = "24.11";
      imports = [
        ../../common/gnome-dconf-common.nix
      ]; 
    };

    # from: https://discourse.nixos.org/t/mixing-stable-and-unstable-packages-on-flake-based-nixos-system/50351/4
    # this allows you to access `pkgsUnstable` anywhere in your config
    _module.args.pkgsUnstable = import inputs.nixpkgs-unstable {
      inherit (pkgs.stdenv.hostPlatform) system;
      inherit (config.nixpkgs) config;
    };

    nixpkgs.config.allowUnfree = true;
    environment.systemPackages = with pkgs; [ 
      ghostty
    ];

    services.printing.enable = true;
    services.openssh.enable = true;
    programs.firefox.enable = true;

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    system.stateVersion = "24.11";
  };

}

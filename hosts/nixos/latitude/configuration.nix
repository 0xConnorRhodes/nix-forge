{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./gnome.nix
      #./kiosk.nix
      ../../common/nixos-common.nix
     #../../common/packages.nix
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
     ../../common/gnome-common.nix
    ]; 
  };

    programs.firefox.enable = true;

    environment.systemPackages = with pkgs; [
      rpi-imager
      git
      neovim
      chezmoi
      zsh
      fish
      zoxide
      fzf
      fd
      bat
      ripgrep
      just
      tree
      zip
      unzip
      htop
      screen
      lf
      magic-wormhole
      powershell
      dua
      mosh
      mediainfo
      aria2
      nh
    ];

    system.stateVersion = "24.11";
  };
}

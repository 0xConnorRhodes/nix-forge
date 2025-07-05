{ config, lib, pkgs, ... }:

{
  hardware.bluetooth.enable = true;
  environment.systemPackages = with pkgs; [
    kdePackages.bluedevil
  ];

  home-manager.users.${config.myConfig.username} = { pkgs, ... }: {
    home.stateVersion = "24.11";
    programs.plasma = {
      enable = true;
      lookAndFeel = {
        globalTheme = "Breeze Dark";
      };
    };
  };
}

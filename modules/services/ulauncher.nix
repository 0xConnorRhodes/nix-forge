{ config, lib, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.ulauncher ];

  home-manager.users.${config.myConfig.username} = {
    home.file.".config/autostart/ulauncher.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Version=1.0
      Name=Ulauncher
      GenericName=Application Launcher
      Exec=ulauncher --hide-window
      Terminal=false
      Categories=System;
      Keywords=system;
    '';
  };
}

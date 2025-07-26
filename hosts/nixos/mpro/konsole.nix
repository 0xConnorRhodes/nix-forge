{ config, lib, pkgs, ... }:

{
  home-manager.users.${config.myConfig.username} = { pkgs, ... }: {
    home.stateVersion = "24.11";
    programs.konsole = {
      enable = true;
      defaultProfile = "MyProfile"; # don't append '.profile' as that will be appended automatically in ~/.config/konsolerc
      profiles."MyProfile" = {
        font.size = 16;
      };
    };
  };
}

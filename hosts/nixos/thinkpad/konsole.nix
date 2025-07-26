{ config, lib, pkgs, ... }:

{
  home-manager.users.${config.myConfig.username} = { pkgs, ... }: {
    home.stateVersion = "24.11";
    programs.konsole = {
      enable = true;
      defaultProfile = "MyProfile.profile";
      profiles."MyProfile" = {
        font.size = 18;
      };
    };
  };
}

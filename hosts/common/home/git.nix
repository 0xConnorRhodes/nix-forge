{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Connor Rhodes";
    userEmail = "connor@rhodes.contact";
    ignores = [
      ".DS_Store"
    ];
    extraConfig = {
      push = {
        default = "current";
        autoSetupRemote = true;
      };
      init = {
        defaultBranch = "main";
      };
    };
  };
}

{ config, pkgs, secrets, ... }:

{
  programs.git = {
    enable = true;
    userName = "Connor Rhodes";
    userEmail = secrets.userInfo.email;
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

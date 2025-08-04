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
      pull = {
        rebase = true;
      };
      push = {
        default = "current";
        autoSetupRemote = true;
      };
      init = {
        defaultBranch = "main";
      };
      alias = {
        d = "!git diff --quiet && git diff --cached || git diff";
        a = "!git add \${1:-.}";
      };
    };
  };
}

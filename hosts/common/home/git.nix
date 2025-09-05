{ config, pkgs, secrets, ... }:

{
  # see also hosts/common/home/shellAliases.nix for git-related aliases
  # and posixFunctions.nix for g() function
  programs.git = {
    enable = true;
    userName = "Connor Rhodes";
    userEmail = secrets.userInfo.email;
    ignores = [
      ".DS_Store"
      ".env"
      ".venv"
    ];
    extraConfig = {
      core = {
        compression = 9; # trade cpu for disks space and network bandwidth
        preloadIndex = true; # cache the index in memory
      };
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
      status = {
        # branch = true;
        showStash = true;
      };
      alias = {
        d = "!git diff --quiet && git diff --cached || git diff";
        a = "!git add \${1:-.}";
        co = "checkout";
      };
    };
  };
}

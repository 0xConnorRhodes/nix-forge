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
      "*.py[oc]"
      "__pycache__/"
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
        s = "status";
        a = "!git add \${1:-.}";
        p = "push";
        u = "pull";
        l = "log";
        b = "branch";
        i = "init";
        cl = "clone";
        c = "commit";
        co = "checkout";
        d = "!git diff --quiet && git diff --cached || git diff";
      };
      url = {
        "git@github.com:0xConnorRhodes/" = {
          insteadOf = "c:";
        };
        "git@github.com:" = {
          insteadOf = "gh:";
        };
      };
    };
  };
}

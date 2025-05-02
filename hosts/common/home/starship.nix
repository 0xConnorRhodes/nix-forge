{config, pkgs, ...}:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status";
      username.disabled = true;
      hostname = {
        ssh_only = true;
        format = "@[$hostname](blue) ";
      };
    };
  };
}
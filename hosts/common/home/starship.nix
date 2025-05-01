{config, pkgs, ...}:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      # format = "$all$directory$character";
      username.disabled = true;
      hostname = {
        ssh_only = true;
        format = "@[$hostname](blue) ";
      };
    };
  };
}
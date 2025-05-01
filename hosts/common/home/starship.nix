{config, pkgs, ...}:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      hostname = {
        ssh_only = true;
        format = "[$ssh_symbol](bold blue) on [$hostname](bold red) ";
      };
    };
  };
}
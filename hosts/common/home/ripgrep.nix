{ config, pkgs, lib, ... }:
let
  rgOptions = [
    "-i" # case insensitive matching
    "--glob=!.git/*" # ignore git directory
  ];
in 
{
  xdg.configFile."ripgrep/ripgreprc".text = builtins.concatStringsSep "\n" rgOptions;

  home.sessionVariables = {
    RIPGREP_CONFIG_PATH = "$HOME/.config/ripgrep/ripgreprc";
  };

  programs.ripgrep = {
    enable = true;
  };
}

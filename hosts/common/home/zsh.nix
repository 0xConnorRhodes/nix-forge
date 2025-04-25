{ config, lib, pkgs, ... }:
let
  shellAliases = import ./shellAliases.nix;
  myPaths = import ./pathDirs.nix;
in 
{
  programs.zsh = {
    enable = true;
    shellAliases = shellAliases.myAliases;
    dotDir = ".config/zsh"; # relative to the users home directory.
    envExtra = ''
      export PATH="${lib.concatStringsSep ":" myPaths.extraPaths}:$PATH"
    '';
    # zsh prompt
    # initExtra will change in future: https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.initContent
    enableCompletion = true;
    initExtra = ''
      autoload -U colors && colors
      setopt prompt_subst
      PROMPT='%{$fg[cyan]%}$USER@%m %{$fg[green]%}%~%{$reset_color%}: '
    '' 
    + # concatenate case-insensitive matching string since it contains '' which breaks the multiline string.
    "\nzstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'";
  };
}

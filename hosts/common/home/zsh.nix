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
    history.path = "$ZDOTDIR/.zsh_history";
    autocd = true; # cd into directory with path only
    autosuggestion.enable = true; # fish-like past command suggestions
    envExtra = ''
      export PATH="${lib.concatStringsSep ":" myPaths.extraPaths}:$PATH"
    '';
    # zsh prompt
    # initExtra will change in future: https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.initContent
    enableCompletion = true;
    completionInit = "autoload -Uz compinit && compinit";
    initExtra = ''
      autoload -U colors && colors
      bindkey -e # force emacs readline keybindings
    '' 
    + # concatenate case-insensitive matching string since it contains '' which breaks the multiline string.
    "\nzstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'";
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}

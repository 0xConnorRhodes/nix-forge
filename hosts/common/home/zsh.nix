{ config, lib, pkgs, osConfig, hostPaths ? [], secrets, ... }:
let
  shellAliases = import ./shellAliases.nix;
  myPaths = import ./pathDirs.nix { inherit pkgs; };
  posixFunctions = import ./posixFunctions.nix;
  shellEnv = import ./shellEnv.nix { inherit lib pkgs osConfig secrets allPaths; };

  # Combine common paths with host-specific paths
  allPaths = osConfig.myConfig.hostPaths ++ myPaths.extraPaths;
in
{
  programs.zsh = {
    enable = true;
    shellAliases = shellAliases.myAliases;
    dotDir = "${osConfig.myConfig.homeDir}/.config/zsh";
    history.path = "$ZDOTDIR/.zsh_history";
    autocd = true; # cd into directory with path only
    autosuggestion.enable = true; # fish-like past command suggestions
    envExtra = shellEnv;
    # zsh prompt
    enableCompletion = true;
    completionInit = "autoload -Uz compinit && compinit";
    initContent = ''
      autoload -U colors && colors
      bindkey -e # force emacs readline keybindings

      export EDITOR="nvim"

      eval "$(rbw gen-completions zsh)"
      eval "$(direnv hook zsh)"
    ''
    + # concatenate case-insensitive matching string since it contains '' which breaks the multiline string.
    "\nzstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'";
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}

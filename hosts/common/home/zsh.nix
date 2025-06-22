{ config, lib, pkgs, osConfig, hostPaths ? [], ... }:
# { config, lib, pkgs, ... }:
let
  shellAliases = import ./shellAliases.nix;
  myPaths = import ./pathDirs.nix;
  posixFunctions = import ./posixFunctions.nix;

  # Combine common paths with host-specific paths
  # allPaths = hostPaths ++ myPaths.extraPaths;
  allPaths = osConfig.myConfig.hostPaths ++ myPaths.extraPaths;
  # allPaths =  myPaths.extraPaths;
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
      export PATH="${lib.concatStringsSep ":" allPaths}:$PATH"
    '';
    # zsh prompt
    enableCompletion = true;
    completionInit = "autoload -Uz compinit && compinit";
    initContent = ''
      autoload -U colors && colors
      bindkey -e # force emacs readline keybindings

      export EDITOR="nvim"
    ''
    + # concatenate case-insensitive matching string since it contains '' which breaks the multiline string.
    "\nzstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'";
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}

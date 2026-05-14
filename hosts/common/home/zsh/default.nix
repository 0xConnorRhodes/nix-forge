{ config, lib, pkgs, osConfig, hostPaths ? [], secrets, ... }:
let
  shellAliases = import ../shellAliases.nix { };
  myPaths = import ../pathDirs.nix { inherit pkgs; };
  posixFunctions = import ../posixFunctions.nix;

  # Combine common paths with host-specific paths
  allPaths = osConfig.myConfig.hostPaths ++ myPaths.extraPaths;
  shellEnv = import ../shellEnv.nix { inherit lib pkgs osConfig secrets allPaths; };
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
      eval "$(${osConfig.myConfig.homeDir}/.local/share/uv/tools/pud/bin/register-python-argcomplete pud)"
      eval "$(${osConfig.myConfig.homeDir}/.local/share/uv/tools/camdb/bin/register-python-argcomplete camdb)"

      # Source sops-managed SSH aliases
      if [ -f "$HOME/.config/sops/ssh_aliases.sh" ]; then
        source "$HOME/.config/sops/ssh_aliases.sh"
      fi

      # Per-directory history
      ${builtins.readFile ./per-directory-history.zsh}
    ''
    + # concatenate case-insensitive matching string since it contains '' which breaks the multiline string.
    "\nzstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'";
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}

{ config, lib, pkgs, ... }:
let
  shellAliases = import ./shellAliases.nix;
  myPaths = import ./pathDirs.nix;
in
{
  programs.bash = {
    enable = true;
    shellAliases = shellAliases.myAliases;
    # interactive shell config
    initExtra = ''
      # Ghostty shell integration for Bash. This should be at the top of your bashrc!
      # if [ -n "''${GHOSTTY_RESOURCES_DIR}" ]; then
      #     builtin source "''${GHOSTTY_RESOURCES_DIR}/shell-integration/bash/ghostty.bash"
      # fi
    '' + (import ./posixFunctions.nix);
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };
}

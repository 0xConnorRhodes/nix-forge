{ config, pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    # NOTE: shell integration with nix may not affect subshells.
    # for subshell support, can manually add integration statement in shell config 
    # per: https://ghostty.org/docs/features/shell-integration
    enableZshIntegration = true;
    enableFishIntegration = true;
  };

  programs.ghostty.settings = {
    theme = "Abernathy";
    font-family = "GeistMono Nerd Font";
    font-feature = [
      "-calt"
      "-liga"
      "-dlig"
    ];
    window-height = 1000;
    window-width = 1000;
    window-padding-color = "background";
    window-padding-x = 0;
    window-padding-y = 0;
    clipboard-paste-protection = false;
  };
}
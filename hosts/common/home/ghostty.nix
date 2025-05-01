{ config, pkgs, ... }:

{
  programs.ghostty.enable = true;
  programs.ghostty.settings = {
    theme = "Abernathy";
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
{ config, pkgs, ... }:

{
  home.file.".config/ghostty/config".text = ''
    window-padding-color = background
    font-size = 16
    font-family = "GeistMono Nerd Font"
    theme = Abernathy
    font-feature = -calt
    font-feature = -liga
    font-feature = -dlig
    window-height = 1000
    window-width = 1000
    window-padding-color = background
    window-padding-x = 0
    window-padding-y = 0
    clipboard-paste-protection = false
  '';
}

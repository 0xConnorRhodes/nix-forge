{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    just
    neovim
  ];

  home.file.".config/ghostty/config".text = ''
    window-padding-color = background
    font-size = 17
    font-family = "Geist Mono"
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

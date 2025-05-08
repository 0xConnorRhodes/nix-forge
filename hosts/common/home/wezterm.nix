{ config, pkgs, ... }:
{
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };
}
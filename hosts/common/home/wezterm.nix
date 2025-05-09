{ config, osConfig, pkgs, ... }:
let
  theme = config.osConfig.wezterm.theme;
in
{
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    extraConfig = ''
      local wezterm = require 'wezterm'
      local config = wezterm.config_builder()

      config.color_scheme = '${theme}'
      config.font_size = 21

      config.window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
      }

      --disable ligatures
      config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

      return config
    '';
  };
}
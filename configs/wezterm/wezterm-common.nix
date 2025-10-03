{ config, osConfig, pkgs, ... }:

{
  home.file.".config/wezterm/wezterm.lua".source = config.lib.file.mkOutOfStoreSymlink ./wezterm.lua;
  home.file.".config/wezterm/keybinds.lua".source = config.lib.file.mkOutOfStoreSymlink ./keybinds.lua;
  home.file.".config/wezterm/host_cfg.lua".source = config.lib.file.mkOutOfStoreSymlink ./host_cfg.lua;
  home.file.".config/wezterm/caps_alt_to_control.lua".source = config.lib.file.mkOutOfStoreSymlink ./caps_alt_to_control.lua;
}

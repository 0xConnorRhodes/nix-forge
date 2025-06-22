{ config, osConfig, pkgs, ... }:

{
  home.file.".config/wezterm/wezterm.lua".source = config.lib.file.mkOutOfStoreSymlink ./wezterm.lua;
  home.file.".config/wezterm/keybinds.lua".source = config.lib.file.mkOutOfStoreSymlink ./keybinds.lua;
  home.file.".config/wezterm/host_cfg.lua".source = config.lib.file.mkOutOfStoreSymlink ./host_cfg.lua;
}

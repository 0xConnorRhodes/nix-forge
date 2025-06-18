{ config, osConfig, pkgs, ... }:

{
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  xdg.desktopEntries = {
    "org.wezfurlong.wezterm" = {
      name = "WezTerm";
      icon = "org.wezfurlong.wezterm";
      type = "Application";
      genericName = "Terminal";
      exec = "env -u WAYLAND_DISPLAY wezterm";
      terminal = false;
      categories= ["System" "TerminalEmulator" "Utility"];
    };
  };

  home.file.".config/wezterm/wezterm.lua".source = config.lib.file.mkOutOfStoreSymlink ../../../configs/wezterm/wezterm.lua;
}

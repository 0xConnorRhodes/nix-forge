{ config, osConfig, pkgs, ... }:

{
  imports = [
    ../../../configs/wezterm/wezterm-common.nix
  ];

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
}

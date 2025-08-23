{ config, pkgs, ... }:

{
  programs.mpv = {
    enable = true;
    config = {
      save-position-on-quit = "yes";
      write-filename-in-watch-later-config = true;
    };
  };
}

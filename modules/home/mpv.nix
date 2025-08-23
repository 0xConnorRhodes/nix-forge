{ inputs, config, ... }:

{
  programs.mpv = {
    enable = true;
  };

  home.file.".config/mpv/mpv.conf".text = ''
    save-position-on-quit=yes
    write-filename-in-watch-later-config=yes
  '';
}

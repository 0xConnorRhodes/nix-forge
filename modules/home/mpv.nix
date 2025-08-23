{ inputs, config, pkgs, ... }:

let
  mpv-lossless-cut = pkgs.fetchFromGitHub rec {
    # must make fetchFromGitHub recursive and bind name to rev to ensure that
    # when rev is changed, the new version is fetched
    name = "mpv-lossless-cut-${rev}";
    owner = "f0e";
    repo = "mpv-lossless-cut";
    rev = "1f895d3";
    sha256 = "sha256-pkrX7zbH6MQFe1971yJGhtpF2fabBrzOnL6S2P6tf34=";
  };
in
{
  programs.mpv = {
    enable = true;
  };

  home.file.".config/mpv/mpv.conf".text = ''
    save-position-on-quit=yes
    write-filename-in-watch-later-config=yes
  '';

  # SCRIPTS

  # multi_cut_mode: seperate => stay seperate files, merge => merge all cuts into one file
  home.file.".config/mpv/script-opts/mpv-lossless-cut.conf".text = ''
    lossless=yes
    output_dir=.
    multi_cut_mode=separate
  '';

  # Install the lossless cut script
  home.file.".config/mpv/scripts/mpv-lossless-cut.lua".source = "${mpv-lossless-cut}/mpv-lossless-cut.lua";
}

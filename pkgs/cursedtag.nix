{ config, pkgs, ... }:

{
  # dependencies
  home.packages = with pkgs; [
    sox
    python312Packages.mutagen
    flac
    vorbis-tools
  ];
}

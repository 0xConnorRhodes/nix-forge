{ config, pkgs, ... }:

# repo: https://github.com/hellricer/cursedtag
# script: https://raw.githubusercontent.com/hellricer/cursedtag/refs/heads/master/cursedtag

{
  # dependencies
  home.packages = with pkgs; [
    sox
    python312Packages.mutagen
    flac
    vorbis-tools
  ];
}

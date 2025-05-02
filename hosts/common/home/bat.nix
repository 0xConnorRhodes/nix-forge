{ config, pkgs, ... }:

{
  programs.bat.enable = true;

  programs.bat.config = {
    # find available languages with `bat --list-languages`
    map-syntax = [
      "flake.lock:JSON"
      "Gemfile*:Ruby"
    ];
  };
}
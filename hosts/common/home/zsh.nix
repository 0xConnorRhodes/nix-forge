{ config, lib, pkgs, ... }:
let
  shellAliases = import ./shellAliases.nix;
  myPaths = import ./pathDirs.nix;
in 
{
  programs.zsh = {
    enable = true;
    shellAliases = shellAliases.myAliases;
    envExtra = ''
      export PATH="${lib.concatStringsSep ":" myPaths.extraPaths}:$PATH"
    '';
  };
}

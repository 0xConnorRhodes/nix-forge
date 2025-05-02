{ config, lib, pkgs, ... }:
let
  shellAliases = import ./shellAliases.nix;
  myPaths = import ./pathDirs.nix;
in 
{
  programs.bash = {
    enable = true;
    shellAliases = shellAliases.myAliases;
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };
}

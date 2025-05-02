{ config, lib, pkgs, ... }:
let
  shellAliases = import ./shellAliases.nix;
  myPaths = import ./pathDirs.nix;
in 
{
  programs.bash = {
    enable = true;
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };
}

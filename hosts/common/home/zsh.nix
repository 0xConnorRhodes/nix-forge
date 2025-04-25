{ config, lib, pkgs, ... }:
let
  shellAliases = import ./shellAliases.nix;
in 
{
  programs.zsh = {
    enable = true;
    shellAliases = shellAliases.myAliases;
  };
}

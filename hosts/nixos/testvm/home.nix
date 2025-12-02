{ config, lib, pkgs, inputs, secrets, ... }:

{
  # Basic home manager configuration
  programs.home-manager.enable = true;
  programs.zsh.enable = true;

  home.stateVersion = "25.11";
}

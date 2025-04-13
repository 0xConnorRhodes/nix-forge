{ inputs, pkgs, ... }:
let
  inherit (inputs) nixpkgs
in
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    zsh
    fish
    fzf
    fd
    bat
    ripgrep
    tree
    zip
    unzip
    htop
    screen
    lf
  ];
}

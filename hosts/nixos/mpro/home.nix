{ config, pkgs, ... }:

{
  imports = [
    ../../common/home/git.nix
    ../../common/home/zsh.nix
    ../../common/home/zoxide.nix
  ];

  home.file.".config/ghostty/config".source = ./config/ghostty;
}

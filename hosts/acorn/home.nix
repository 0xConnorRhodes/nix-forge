{ config, pkgs, inputs, ... }:
let
  pkgsUnstable = import inputs.nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;
    inherit (config.nixpkgs) config;
  };
in
{
  # make pkgsUnstable available to all modules
  _module.args.pkgsUnstable = pkgsUnstable;
  imports = [
    ../common/home/git.nix
    ../common/home/bash.nix
    ../common/home/zsh.nix
    ../common/home/ripgrep.nix
    ../common/home/zoxide.nix
    ../common/home/starship.nix
    ../common/home/bat.nix
  ];

  home.sessionVariables = {
    EDITOR = "neovim";
  };

  programs.zsh = {
    dirHashes = {
      dwn = "$HOME/Downloads";
    };
    initContent = import ../common/home/posixFunctions.nix;
  };
}

{ config, pkgs, inputs, ... }:
{
  # make pkgsUnstable available to all modules
  imports = [
    ../../common/home/bash.nix
    ../../common/home/zsh.nix
    ../../common/home/ripgrep.nix
    ../../common/home/zoxide.nix
    ../../common/home/starship.nix
    ../../common/home/bat.nix
  ];

  home.sessionVariables = {
    EDITOR = "neovim";
  };

  programs.zsh = {
    dirHashes = {
      docs = "$HOME/Documents";
    };
    initContent = import ../../common/home/posixFunctions.nix;
  };
}

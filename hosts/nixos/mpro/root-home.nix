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
    ../../common/home/bash.nix
    ../../common/home/zsh.nix
    ../../common/home/ripgrep.nix
    ../../common/home/zoxide.nix
    # ../../common/home/starship.nix
    ../../common/home/bat.nix
    ../../common/home/lf.nix
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.zsh = {
    initContent = import ../../common/home/posixFunctions.nix;
  };

  xdg.configFile = {
    "screen/screenrc".source = ../../common/home/config/screenrc;
  };
}

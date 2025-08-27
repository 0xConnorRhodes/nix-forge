{ config, lib, pkgs, inputs, secrets, ... }:

{
  # make pkgsUnstable available to all modules
  _module.args.pkgsUnstable = import inputs.nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;
    inherit (config.nixpkgs) config;
  };

  programs.nix-index-database.comma.enable = true;

  environment.systemPackages = with pkgs; [
    git
    htop
    neovim
    wget
    curl
    tree
    unzip
    trash
  ];
}

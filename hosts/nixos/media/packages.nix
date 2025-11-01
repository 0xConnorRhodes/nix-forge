{ config, lib, pkgs, inputs, secrets, ... }:
let
  # Hugo pinned to v0.105.0 from specific nixpkgs commit
  pkgsHugo105 = import inputs.pinned-hugo {
    inherit (pkgs.stdenv.hostPlatform) system;
    inherit (config.nixpkgs) config;
  };
in

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
    trashy
    yq-go
    git-crypt
    magic-wormhole
    zip
    unzip
    fd
    nh
    screen
    mpv
    vlc
    pkgsHugo105.hugo # Hugo v0.105.0 from pinned nixpkgs
  ];
}

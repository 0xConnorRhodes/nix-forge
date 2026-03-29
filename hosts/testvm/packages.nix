{ config, lib, pkgs, pkgsUnstable, inputs, secrets, ... }:

{
  # make pkgsUnstable available to all modules
  _module.args.pkgsUnstable = import inputs.nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;
    inherit (config.nixpkgs) config;
  };

  programs.nix-index-database.comma.enable = true;
  nixpkgs.config.allowUnfree = true;

  # Include common CLI packages but no GUI packages
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
    zip
    fd
    screen
    croc
    ripgrep
    pkgsUnstable.claude-code
  ];
}

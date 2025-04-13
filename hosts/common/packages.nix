{ inputs, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # install from unstable by prefixing package with unstable, eg: unstable.go
    git
    neovim
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
    magic-wormhole
    unstable.go
  ];
}

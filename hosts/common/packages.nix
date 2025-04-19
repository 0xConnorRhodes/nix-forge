{ inputs, pkgs, config, pkgsUnstable, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # install from unstable by prefixing package with pkgsUnstable, eg: pkgsUnstable.go
    git
    neovim
    chezmoi
    zsh
    fish
    zoxide
    fzf
    fd
    bat
    ripgrep
    just
    tree
    zip
    unzip
    htop
    screen
    lf
    magic-wormhole
    powershell
    dua
    mosh
    mediainfo
    aria2
    nh # https://github.com/nix-community/nh
  ];
}

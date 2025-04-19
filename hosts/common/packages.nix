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
    nix-output-monitor
    tealdeer
    dua
    htop
    gotop
    btop-rocm # TODO: configure for smaller screen: https://github.com/aristocratos/btop?tab=readme-ov-file#configurability
    nnn
    rclone

    # python packages
    (python3.withPackages (python-pkgs: with python-pkgs; [
      requests
      jinja2
    ]))

    # ruby packages
    (ruby.withPackages (ruby-pkgs: with ruby-pkgs; [
      pry
    ]))
  ];
}

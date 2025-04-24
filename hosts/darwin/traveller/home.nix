{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    git
    git-crypt
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
    screen
    lf
    magic-wormhole
    powershell
    dua
    mosh
    mediainfo
    aria2
    # nh # TODO: install from unstable for darwin support?
    # comma
    tealdeer
    htop
    gotop
    nnn
    rclone

    # mac-sepecific
    blueutil
    ffmpeg-full
    imagemagick
    iperf
    darwin.iproute2mac
    lazydocker
    
    # LATER
    # skhd
    # ruby
    # lua
    # mpv
    # nodejs
    # tesseract
  ];

  home.file.".config/ghostty/config".text = ''
    window-padding-color = background
    font-size = 17
    font-family = "Geist Mono"
    theme = Abernathy
    font-feature = -calt
    font-feature = -liga
    font-feature = -dlig
    window-height = 1000
    window-width = 1000
    window-padding-color = background
    window-padding-x = 0
    window-padding-y = 0
    clipboard-paste-protection = false
  '';
}

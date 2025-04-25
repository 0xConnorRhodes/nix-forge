{ config, pkgs, inputs, secrets, ... }:
let
  pkgsUnstable = import inputs.nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;
    inherit (config.nixpkgs) config;
  };
in
{
  imports = [
    ./comma.nix
    ../../common/home/git.nix
  ];

  home.packages = with pkgs; [
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
    tealdeer
    htop
    gotop
    nnn
    rclone

    # mac-specific
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

    # python packages
    (python3.withPackages (python-pkgs: with python-pkgs; [
      requests
      jinja2
    ]))

    # ruby packages
    (ruby.withPackages (ruby-pkgs: with ruby-pkgs; [
      pry
      dotenv
    ]))
  ];

  home.file.".config/ghostty/config".text = ''
    window-padding-color = background
    font-size = 21
    font-family = "GeistMono"
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

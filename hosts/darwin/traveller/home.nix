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
    ./home-secret.nix
    ../../common/home/git.nix
    ../../common/home/zsh.nix
    ../../common/home/zoxide.nix
  ];

  home.sessionVariables = {
    PAGER = "less";
    CLICLOLOR = 1;
    EDITOR = "nvim";
  };

  home.packages = with pkgs; [
    git-crypt
    neovim
    chezmoi
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
    cloudflared

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

  xdg.configFile."skhd/skhdrc".source = ./config/skhdrc;
  home.file.".config/ghostty/config".source = ./config/ghostty;
}

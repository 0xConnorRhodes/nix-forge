{ config, pkgs, inputs, secrets, ... }:
let
  pkgsUnstable = import inputs.nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;
    inherit (config.nixpkgs) config;
  };
in
{
  # comma config
  imports = [ inputs.nix-index-database.hmModules.nix-index ];
  nixpkgs.config.allowUnfree = true;
  # NOTE: if comma produces warning:
  # '/nix/var/nix/profiles/per-user/root/channels'
  # can run `sudo mkdir /nix/var/nix/profiles/per-user/root/channels` to clear
  programs.nix-index-database.comma.enable = true;

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
  ];

  home.file.".config/ghostty/config".text = ''
    window-padding-color = background
    font-size = 21
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

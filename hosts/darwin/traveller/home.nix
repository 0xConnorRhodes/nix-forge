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
    EDITOR = "nvim";
  };

  home.packages = with pkgs; [
    zoxide
    powershell
    mediainfo
    aria2
    tealdeer
    htop
    gotop
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
  ] ++ (import ../../common/packages.nix { pkgs = pkgs; });

  xdg.configFile."skhd/skhdrc".source = ./config/skhdrc;
  home.file.".config/ghostty/config".source = ./config/ghostty;

  # Don't show the "Last login" message for every new terminal.
  home.file.".hushlogin" = { text = ""; };
}

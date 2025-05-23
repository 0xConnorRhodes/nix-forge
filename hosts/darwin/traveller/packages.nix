{ config, pkgs, inputs, secrets, ... }:
let
  pkgsUnstable = import inputs.nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;
    inherit (config.nixpkgs) config;
  };

  ruby = pkgs.ruby_3_4;
  httparty = pkgs.bundlerEnv {
    name = "httparty";
    ruby = ruby;
    gemdir = ../../../pkgs/ruby/httparty;
  };
in
{
  home.packages = with pkgs; [
    zoxide
    powershell
    mediainfo
    aria2
    tealdeer
    htop
    gotop
    # rclone
    # android-tools # provides adb
    pkgsUnstable.bluesnooze # not in 24.11, must launch once and choose "launch at login" from menu bar icon
    raycast
    scrcpy
    wezterm
    #imagemagickBig # includes ghostscript
    poppler_utils # provides pdftoppm file.pdf -png
    minikube
    kubectl
    gcc # needed for neovim plugins
    pkgsUnstable.neovim

    # mac-specific
    blueutil
    ffmpeg-full
    iperf
    iproute2mac
    lazydocker
    cloudflared
    podman
    podman-compose
    unixtools.watch
    unixtools.ping
    emacs-macport
    lima
    mpv
    
    # GUI
    utm
    rectangle
    neovide

    # LATER
    # lua
    # mpv
    # nodejs
    # tesseract

    # python packages
    (python3.withPackages (python-pkgs: with python-pkgs; [
      requests
      jinja2
      ipython
    ]))

    # ruby packages
    (ruby.withPackages (ruby-pkgs: with ruby-pkgs; [
      pry
      dotenv
      highline
      httparty # local package
    ]))
  ] 
  ++ (import ../../common/packages.nix { pkgs = pkgs; });
}

{ config, pkgs, inputs, secrets, ... }:
let
  pkgsUnstable = import inputs.nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;
    inherit (config.nixpkgs) config;
  };

  flakePackages = (builtins.mapAttrs ( name: value: value.packages.${pkgs.system}.default) {
      inherit (inputs)
      json2nix;
    }
  );

  # Hugo pinned to v0.105.0 from specific nixpkgs commit
  pkgsHugo105 = import inputs.nixpkgs-hugo-105 {
    inherit (pkgs.stdenv.hostPlatform) system;
    inherit (config.nixpkgs) config;
  };

  ruby = pkgs.ruby_3_4;
  myGems = pkgs.bundlerEnv {
    name = "myGems";
    ruby = ruby;
    gemdir = ../../../pkgs/ruby/myGems;
  };
in
{
  # make pkgsUnstable available to all modules
  _module.args.pkgsUnstable = pkgsUnstable;

  home.packages = with pkgs; [
    zoxide
    powershell
    mediainfo
    aria2
    tealdeer
    htop
    gotop
    bluesnooze # must launch once and choose "launch at login" from menu bar icon
    scrcpy
    wezterm
    #imagemagickBig # includes ghostscript
    poppler_utils # provides pdftoppm file.pdf -png
    minikube
    kubectl
    gcc # needed for neovim plugins
    pkgsUnstable.neovim
    wget
    buku
    caligula
    doppler
    ansible
    sshpass # needed by ansible
    lazysql

    # mac-specific
    blueutil
    ffmpeg-full
    iperf
    iproute2mac
    lazydocker
    cloudflared
    unixtools.watch
    unixtools.ping
    emacs-macport
    lima
    mpv
    piper-tts
    gemini-cli
    gh
    pkgsHugo105.hugo # Hugo v0.105.0 from pinned nixpkgs

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
      ipython
    ]))

    # ruby packages
    (ruby.withPackages (ruby-pkgs: with ruby-pkgs; [
      pry
      dotenv
      highline
      myGems # local ruby gem packages
      ruby-lsp # for vscode ruby lsp
    ]))
  ]
  ++ (import ../../common/packages.nix { pkgs = pkgs; })
  ++ pkgs.lib.attrValues flakePackages;
}

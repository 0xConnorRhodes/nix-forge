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

  pinnedHugo = import inputs.pinned-hugo {
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
    #imagemagickBig # includes ghostscript
    poppler-utils # provides pdftoppm file.pdf -png
    minikube
    kubectl
    gcc # needed for neovim plugins
    pkgsUnstable.neovim
    wget
    caligula
    ansible
    sshpass # needed by ansible
    lazysql
    posting
    pandoc
    texlive.combined.scheme-full # needed for pandoc pdf conversion

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
    #lima
    mpv
    gemini-cli
    gh
    pinnedHugo.hugo
    cht-sh

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
      myGems # local ruby gem packages
      # ruby-lsp # for vscode ruby lsp - commented out since VSCode is disabled
    ]))
  ]
  ++ (import ../../common/packages.nix { pkgs = pkgs; })
  ++ pkgs.lib.attrValues flakePackages;
}

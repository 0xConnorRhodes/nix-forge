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
  imports = [
    ./comma.nix
    ./home-secret.nix
    ../../common/home/git.nix
    ../../common/home/bash.nix
    ../../common/home/zsh.nix
    ../../common/home/ripgrep.nix
    ../../common/home/zoxide.nix
    ../../common/home/starship.nix
    ../../common/home/bat.nix
    ../../common/home/lf.nix
    ../../common/home/vscode.nix
    # ../../common/home/imagemagick.nix
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    # colon seperated list of dirs to be added to the default ruby $LOAD_PATH for importing modules
    RUBYLIB = "$HOME/code/ruby-modules/lib:$HOME/code/camdb/lib:$HOME/code/vapi/lib"; 
  };

  # needed for shell integration when ghostty is installed with brew instead of nix
  programs.zsh.initExtraFirst = ''
    # Ghostty shell integration for zsh. This should be at the top of your bashrc!
    if [ -n "$GHOSTTY_RESOURCES_DIR" ]; then
        builtin source "$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration"
    fi
  '';

  programs.zsh.shellAliases = {
    yo = "open -a yoink";
  };

  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  programs.vscode = {
    userSettings = {
      editor.fontSize = 17;
      terminal.integrated.fontSize = 17;
      chat.editor.fontSize = 16;
      window.zoomLevel = 1;
    };
  };

  programs.zsh = {
    dirHashes= {
      dwn = "$HOME/Downloads";
      docs = "$HOME/Documents";
    };
    initExtra = import ../../common/home/posixFunctions.nix;
  };

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

    # mac-specific
    blueutil
    ffmpeg-full
    iperf
    darwin.iproute2mac
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
  ] ++ (import ../../common/packages.nix { pkgs = pkgs; });

  xdg.configFile = {
    # "skhd/skhdrc".source = ./config/skhdrc;
    "ghostty/config".source = ./config/ghostty;
    "screen/screenrc".source = ../../common/home/config/screenrc;
  };


  # Don't show the "Last login" message for every new terminal.
  home.file.".hushlogin" = { text = ""; };
}

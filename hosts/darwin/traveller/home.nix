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

  home.packages = with pkgs; [
    zoxide
    powershell
    mediainfo
    aria2
    tealdeer
    htop
    gotop
    rclone
    android-tools # provides adb

    # mac-specific
    blueutil
    ffmpeg-full
    imagemagick
    iperf
    darwin.iproute2mac
    lazydocker
    cloudflared
    podman
    podman-compose
    
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
    ]))

    # ruby packages
    (ruby.withPackages (ruby-pkgs: with ruby-pkgs; [
      pry
      dotenv
      highline
    ]))
  ] ++ (import ../../common/packages.nix { pkgs = pkgs; });

  xdg.configFile."skhd/skhdrc".source = ./config/skhdrc;
  home.file.".config/ghostty/config".source = ./config/ghostty;

  # Don't show the "Last login" message for every new terminal.
  home.file.".hushlogin" = { text = ""; };
}

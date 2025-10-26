# packages exclusive to nixOS hosts (mostly GUI programs)
{ inputs, pkgs, config, pkgsUnstable, ... }:
let
  ruby = pkgs.ruby_3_4;
  myGems = pkgs.bundlerEnv {
    name = "myGems";
    ruby = ruby;
    gemdir = ../../pkgs/ruby/myGems;
  };
in
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # install from unstable by prefixing package with pkgsUnstable, eg: pkgsUnstable.go
    mpv
    nodePackages.npm # mpv cut dependency
    audacity
    pavucontrol
    podman-compose
    lazydocker
    distrobox
    rclone-browser
    wev # xev-style key viewer for wayland
    wl-clipboard # access clipboard from terminal with wl-copy and wl-paste
    killall
    # bitwarden-desktop
    trashy
    wezterm
    neovide
    caligula # write ISOs to drives
    pkgsUnstable.google-chrome
    gpu-screen-recorder

    nerd-fonts.geist-mono
    nerd-fonts.jetbrains-mono

    # GUI programs
    gnumeric
    abiword

    # common ruby env
    (ruby.withPackages (ruby-pkgs: with ruby-pkgs; [
      pry
      dotenv
      myGems
      highline
    ]))

    # python packages
    (python3.withPackages (python-pkgs: with python-pkgs; [
      requests
      jinja2
      pyaml
      ipython
    ]))

    # nonfree
    pkgsUnstable.warp-terminal
  ];
}

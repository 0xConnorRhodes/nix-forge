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
    gparted
    distrobox
    gpu-screen-recorder
    rclone-browser
    wev # xev-style key viewer for wayland
    wl-clipboard # access clipboard from terminal with wl-copy and wl-paste
    killall
    # bitwarden-desktop
    chromium
    element-desktop
    trashy
    wezterm
    neovide

    nerd-fonts.geist-mono
    nerd-fonts.jetbrains-mono

    # GUI programs
    gnumeric
    inputs.zen-browser.packages.${pkgs.system}.default

    # common ruby env
    (ruby.withPackages (ruby-pkgs: with ruby-pkgs; [
      pry
      dotenv
      myGems
      highline
    ]))

    # nonfree
    obsidian
    #vscode
    pkgsUnstable.warp-terminal
    pkgsUnstable.code-cursor
    pkgsUnstable.windsurf
    pkgsUnstable.discord
    pkgsUnstable.slack
    pkgsUnstable.vivaldi
  ];
}

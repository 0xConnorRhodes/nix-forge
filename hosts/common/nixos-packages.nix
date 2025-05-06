# packages exclusive to nixOS hosts (mostly GUI programs)
{ inputs, pkgs, config, pkgsUnstable, ... }:

{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # install from unstable by prefixing package with pkgsUnstable, eg: pkgsUnstable.go
    ghostty
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


    # Nerd Fonts
    # pass keys from https://github.com/NixOS/nixpkgs/blob/nixos-24.11/pkgs/data/fonts/nerdfonts/shas.nix
    # as strings to selectively install nerd fonts
    (nerdfonts.override { fonts = [
      "GeistMono"
      "JetBrainsMono"
    ];})

    # nonfree
    obsidian
    vscode
    pkgsUnstable.warp-terminal
    pkgsUnstable.code-cursor
    pkgsUnstable.windsurf
    pkgsUnstable.discord
    pkgsUnstable.slack
  ];
}

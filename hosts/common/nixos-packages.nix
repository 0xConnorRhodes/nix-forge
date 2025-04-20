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
    obsidian
    nerdfonts
    distrobox
    gpu-screen-recorder
    rclone-browser
    wev # xev-style key viewer for wayland
    killall

    pkgsUnstable.vscode-fhs
    pkgsUnstable.warp
    pkgsUnstable.code-cursor
    pkgsUnstable.windsurf
    pkgsUnstable.discord
  ];
}

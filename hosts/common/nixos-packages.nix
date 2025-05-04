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
    nerdfonts
    distrobox
    gpu-screen-recorder
    rclone-browser
    wev # xev-style key viewer for wayland
    wl-clipboard # access clipboard from terminal with wl-copy and wl-paste
    killall
    # bitwarden-desktop
    chromium
    element-desktop

    # nonfree
    obsidian
    # vscode
    # pkgsUnstable.vscode-fhs
    pkgsUnstable.warp-terminal
    pkgsUnstable.code-cursor
    pkgsUnstable.windsurf
    pkgsUnstable.discord
    pkgsUnstable.slack
  ];
#   ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
#   {
#     name = "copilot";
#     publisher = "GitHub";
#     version = "1.312.0";
#     sha256 = "sha256-CsOOE/Lpfv1JL9h3KaHfGXIDZcF9KuWo4qIwzwFT1Gk=";
#   }
#   {
#     name = "copilot-chat";
#     publisher = "GitHub";
#     version = "0.26.7";
#     sha256 = "sha256-aR6AGU/boDmYef0GWna5sUsyv9KYGCkugWpFIusDMNE=";
#   }
# ];
}

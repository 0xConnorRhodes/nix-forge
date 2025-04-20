{ config, lib, pkgs, ... }:
let
  username = config.myConfig.username;
  enable_autologin = false;
in
{
  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = enable_autologin;
  services.displayManager.autoLogin.user = username;

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = enable_autologin;
  systemd.services."autovt@tty1".enable = enable_autologin;

  environment.systemPackages = with pkgs; [
    #gsettings-desktop-schemas
    dconf2nix
    gnome-tweaks
    gnome-themes-extra # provides adwaita dark theme in gnome tweaks for legacy applications
  ];
}

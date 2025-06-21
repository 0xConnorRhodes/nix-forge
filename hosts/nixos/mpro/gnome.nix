{ config, lib, pkgs, ... }:
let
  enable_autologin = false;
in
{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = enable_autologin;
  services.displayManager.autoLogin.user = config.myConfig.username;

  # don't autosuspend on gdm login screen
  services.xserver.displayManager.gdm.autoSuspend = false;

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

{ config, lib, pkgs, ... }:

{
  imports = [
    ../../modules/nixos/ulauncher.nix
  ]

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

  environment.systemPackages = with pkgs; [
    #gsettings-desktop-schemas
    gparted
    dconf2nix
    gnome-tweaks
    gnome-themes-extra # provides adwaita dark theme in gnome tweaks for legacy applications
  ];

  environment.gnome.excludePackages = (with pkgs; [
    epiphany
    geary
    gnome-terminal
    gnome-console
    gnome-calendar
    gnome-weather
    gnome-tour
    gnome-contacts
    gnome-clocks
    gnome-maps
    totem # video player
    gnome-user-docs
    gnome-calculator
    gnome-music
    decibels # audio player
  ]);

  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "wezterm";
  };
}

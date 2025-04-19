{ config, lib, pkgs, ... }:

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
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  environment.systemPackages = with pkgs; [
    #gsettings-desktop-schemas
    dconf2nix
    gnome-tweaks
    gnome-themes-extra # provides adwaita dark theme in gnome tweaks for legacy applications
  ];

  environment.gnome.excludePackages = (with pkgs; [
    epiphany
    geary
    gnome-terminal
  ]);
}

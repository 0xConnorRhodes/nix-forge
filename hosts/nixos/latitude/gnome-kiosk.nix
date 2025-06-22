{ config, lib, pkgs, ... }:

{
  # suspend
  services.xserver.displayManager.gdm.autoSuspend = false;

  services.logind.extraConfig = ''
    HandleLidSwitchExternalPower=ignore
    HandleLidSwitch=ignore
  '';

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    gnome-monitor-config
  ];
}

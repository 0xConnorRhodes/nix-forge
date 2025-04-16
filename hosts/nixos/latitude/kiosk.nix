{ config, lib, pkgs, ... }:
{
  # suspend
  services.xserver.displayManager.gdm.autoSuspend = false;

  services.logind.extraConfig = ''
    HandleLidSwitchExternalPower=ignore
    HandleLidSwitch=ignore
  '';
}

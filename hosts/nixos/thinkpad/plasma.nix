{ config, lib, pkgs, ... }:

{
  hardware.bluetooth.enable = true;
  environment.systemPackages = with pkgs; [
    kdePackages.bluedevil
  ];
}

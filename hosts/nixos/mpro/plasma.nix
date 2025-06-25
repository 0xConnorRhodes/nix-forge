{ config, lib, pkgs, ... }:

{
  imports = [
    ../../common/plasma-common.nix
  ];

  hardware.bluetooth.enable = true;


  environment.systemPackages = with pkgs; [
    kdePackages.bluedevil
  ];
}

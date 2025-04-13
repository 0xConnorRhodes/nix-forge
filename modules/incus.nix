{ config, lib, pkgs, ... }:
let
  user = "connor";
in
{
  environment.systemPackages = with pkgs; [
    incus
  ];

  virtualization.incus.enable = true;
  users.users.${user}.extraGroups = ["incus-admin"];

  networking.firewall.trustedInterfaces = [ "incusbr0" ];
  networking.nftables.enable = true;
}


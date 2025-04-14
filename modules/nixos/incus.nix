{ config, lib, pkgs, ... }:
let
  username = "connor";
in
{
  environment.systemPackages = with pkgs; [
    incus
  ];

  virtualisation.incus.enable = true;
  users.users.${username}.extraGroups = ["incus-admin"];

  networking.firewall.trustedInterfaces = [ "incusbr0" ];
  networking.nftables.enable = true;
}


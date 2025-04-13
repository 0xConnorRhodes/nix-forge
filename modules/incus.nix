{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    incus
  ];

  virtualization.incus.enable = true;
  users.users.connor.extraGroups = ["incus-admin"];

  networking.firewall.trustedInterfaces = [ "incusbr0" ];
  networking.nftables.enable = true;
}


{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    incus
  ];

  virtualisation.incus.enable = true;
  users.users.${config.myConfig.username}.extraGroups = ["incus-admin"];

  networking.firewall.trustedInterfaces = [ "incusbr0" ];
  networking.nftables.enable = true;
}


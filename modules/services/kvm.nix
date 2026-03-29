{ config, lib, pkgs, ... }:

{
  users.users.${config.myConfig.username}.extraGroups = ["libvirtd"];

  # kvm/virt-manager
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = [ config.myConfig.username ];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  networking.firewall.trustedInterfaces = [ "virbr0" ];
  networking.nftables.enable = true;

  # note: must imperatively follow steps in wiki: "~/notes/virt-manager kvm"
  # to create kvm NATed network and set to autostart
}


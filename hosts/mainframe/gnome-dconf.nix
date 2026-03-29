{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {

    # fix virt-manager could not detect default hypervisor
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };

  };
}
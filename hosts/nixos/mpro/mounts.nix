{ config, pkgs, ... }:

{
  fileSystems."/scary-new" = {
    device = "/dev/disk/by-uuid/46e69ff6-a3c4-4862-a825-884682d27543";
    fsType = "ext4";
    options = ["nofail"];
  };
}

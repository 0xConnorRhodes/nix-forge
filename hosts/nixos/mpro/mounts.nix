{ config, pkgs, ... }:

{
  fileSystems."/scary" = {
    device = "/dev/disk/by-uuid/29959e00-6cc9-46e5-87a8-eb479a45db67";
    fsType = "ext4";
    options = ["nofail"];
  };
}

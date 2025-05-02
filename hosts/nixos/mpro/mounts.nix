{ config, ... }:

{
  fileSystems."/scary" = {
    device = "/dev/disk/by-uuid/29959e00-6cc9-46e5-87a8-eb479a45db67";
    fsType = "ext4";
    options = ["nofail"];
  };

  fileSystems."/mnt/zmedia" = {
    device = "192.168.86.10:/zstore/media";
    fsType = "nfs4";
    options = [ "rw" "x-systemd.automount" "noauto" ];
  };

  fileSystems."/mnt/zdata" = {
    device = "192.168.86.10:/zstore/data";
    fsType = "nfs4";
    options = [ "rw" "x-systemd.automount" "noauto" ];
  };

  fileSystems."/mnt/zfiles" = {
    device = "192.168.86.10:/zstore/files";
    fsType = "nfs4";
    options = [ "rw" "x-systemd.automount" "noauto" ];
  };

  fileSystems."/mnt/sfs" = {
    device = "192.168.86.10:/zstore/static_files";
    fsType = "nfs4";
    options = [ "rw" "x-systemd.automount" "noauto" ];
  };
}
{ config, pkgs, ... }:

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

  environment.systemPackages = with pkgs; [
    mergerfs
  ];

  fileSystems."/mnt/jbod" = {
    depends = [
      # The `disk*` mounts have to be mounted in this given order.
      "/mnt/disks/disk01"
      "/mnt/disks/disk02"
      ];
      device = "/mnt/disks/disk*";
      fsType = "mergerfs";
      options = ["defaults" "category.create=mfs" "minfreespace=20G" "fsname=mergerfs-jbod"];
    };

  fileSystems."/mnt/disks/disk01" = {
    device = "/dev/disk/by-uuid/46e69ff6-a3c4-4862-a825-884682d27543";
      fsType = "ext4";
    };

  fileSystems."/mnt/disks/disk02" = {
    device = "/dev/disk/by-uuid/99b0b4c4-8386-423f-a01f-c2bd903c155b";
      fsType = "ext4";
    };
}
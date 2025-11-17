{ config, pkgs, ... }:

{
  fileSystems."/scary" = {
    device = "/dev/disk/by-uuid/29959e00-6cc9-46e5-87a8-eb479a45db67";
    fsType = "ext4";
    options = ["nofail"];
  };

  fileSystems."/zstore" = {
    device = "zstore";
    fsType = "zfs";
    options = ["nofail"];
  };

  fileSystems."/zstore/data" = {
    device = "zstore/data";
    fsType = "zfs";
    options = ["nofail"];
  };

  fileSystems."/zstore/files" = {
    device = "zstore/files";
    fsType = "zfs";
    options = ["nofail"];
  };

  fileSystems."/zstore/immich_library" = {
    device = "zstore/immich_library";
    fsType = "zfs";
    options = ["nofail"];
  };

  fileSystems."/zstore/immich_library_bak" = {
    device = "zstore/immich_library_bak";
    fsType = "zfs";
    options = ["nofail"];
  };

  fileSystems."/zstore/media" = {
    device = "zstore/media";
    fsType = "zfs";
    options = ["nofail"];
  };

  fileSystems."/zstore/music_library" = {
    device = "zstore/music_library";
    fsType = "zfs";
    options = ["nofail"];
  };

  fileSystems."/zstore/static_files" = {
    device = "zstore/static_files";
    fsType = "zfs";
    options = ["nofail"];
  };
}

{ config, lib, pkgs, pkgsUnstable, ... }:

{
  services.immich = {
    enable = true;
    host = "127.0.0.1";
    port = 4312;
    openFirewall = true;
    mediaLocation = "/zstore/immich_library";

    database = {
      enable = true;
      createDB = true;
      name = "immich";
      user = "immich";
      host = "/run/postgresql";
      enableVectorChord = true;
      enableVectors = true; # Keep pgvecto.rs for compatibility
    };

    redis = {
      enable = true;
    };

    machine-learning = {
      enable = true;
    };
  };
}

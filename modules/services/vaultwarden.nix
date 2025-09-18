{ config, pkgs, pkgsUnstable, ... }:

{
  services.vaultwarden = {
    enable = true;
    package = pkgs.vaultwarden;
    dbBackend = "sqlite";
    backupDir = "/var/backup/vaultwarden";
    config = {
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = "33461";
      DATA_FOLDER = "/var/lib/vaultwarden/data";
    };
  };
}

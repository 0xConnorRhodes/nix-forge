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

  # systemd.timers."backup-vaultwarden-files" = {
  #   wantedBy = [ "timers.target" ];
  #   timerConfig = {
  #     OnCalendar = "daily"; # Examples: daily, weekly, hourly, *-*-* 03:00:00
  #     Persistent = true; # Run missed jobs on next boot
  #     Unit = "backup-vaultwarden-files.service";
  #   };
  # };

  # systemd.services."backup-vaultwarden-files" = {
  #   path = with pkgs; [
  #     sqlite
  #     rclone
  #     tar
  #     gzip
  #   ];
  #   script = ''
  #     set -eu
  #     # stop service
  #     # .backup database to /var/lib/vaultwarden/backups
  #     # tar the whole thing to /tmp then copy to zstore and rclone do db_enc
  #   '';
  #   serviceConfig = {
  #     Type = "oneshot";
  #     User = "${config.myConfig.username}";
  #   };
  # };
}

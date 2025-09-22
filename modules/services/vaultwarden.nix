{ config, pkgs, pkgsUnstable, ... }:

let
  backupScript = pkgs.writeShellScript "backup-vaultwarden" ''
    set -eu
    SOURCE_DB="/var/lib/vaultwarden/data/db.sqlite3"
    BACKUP_DB="/var/lib/vaultwarden/backups/$(date +%y%m%d)-db.sqlite"
    sqlite3 "$SOURCE_DB" ".backup '$BACKUP_DB'"
  '';
in
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

  systemd.timers."backup-vaultwarden-files" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily"; # Examples: daily, weekly, hourly, *-*-* 03:00:00
      Persistent = true; # Run missed jobs on next boot
      Unit = "backup-vaultwarden-files.service";
    };
  };

  systemd.services."backup-vaultwarden-files" = {
    path = with pkgs; [
      sqlite
      rclone
      gnutar
      gzip
      coreutils
    ];
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      ExecStartPre = "${pkgs.systemd}/bin/systemctl stop vaultwarden.service";
      ExecStart = "${backupScript}";
      ExecStartPost = "${pkgs.systemd}/bin/systemctl start vaultwarden.service";
    };
  };
}

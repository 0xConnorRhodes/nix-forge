{ config, pkgs, pkgsUnstable, ... }:

let
  backupScript = pkgs.writeShellScript "backup-vaultwarden" ''
    set -eu
    PATH="/run/wrappers/bin:$PATH"

    SOURCE_DB="/var/lib/vaultwarden/data/db.sqlite3"
    BACKUP_DB="/var/lib/vaultwarden/backups/$(date +%y%m%d)-db.sqlite"
    BACKUP_FILENAME="$(date +%y%m%d)-vaultwarden.tar.gz"
    BACKUP_FILE="/tmp/$BACKUP_FILENAME"
    ZSTORE_PATH="/zstore/data/records/db_backups/vaultwarden"

    sqlite3 "$SOURCE_DB" ".backup '$BACKUP_DB'"
    tar -czpf "$BACKUP_FILE" -C /var/lib vaultwarden
    cp "$BACKUP_FILE" "$ZSTORE_PATH/"
    chown 1000:100 "$ZSTORE_PATH/$BACKUP_FILENAME"
    sudo -u ${config.myConfig.username} rclone copy "$ZSTORE_PATH/$BACKUP_FILENAME" gdrive_enc:db_backups/vaultwarden
    rm "$BACKUP_FILE"
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

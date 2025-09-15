{ config, pkgs, ... }:

{
  systemd.timers."readeck-backup" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily"; # Examples: daily, weekly, hourly, *-*-* 03:00:00
      Persistent = true; # Run missed jobs on next boot
      Unit = "readeck-backup.service";
    };
  };

  systemd.services."readeck-backup" = {
    path = with pkgs; [
      docker
      rclone
    ];
    script = ''
      set -eu
      # --- Configuration ---
      CONTAINER_NAME="readeck"
      CONTAINER_BACKUP_PATH="/readeck/export.zip"
      HOST_BACKUP_FILENAME="$(date +%y%m%d)-readeck.zip"
      LOCAL_BACKUP_DIR="/mnt/zdata/records/db_backups/readeck"
      RCLONE_REMOTE="dropbox_enc:db_backups/readeck"
      # ---------------------

      docker exec "$CONTAINER_NAME" readeck export -config /readeck/config.toml "$CONTAINER_BACKUP_PATH"
      docker cp "$CONTAINER_NAME:$CONTAINER_BACKUP_PATH" "$LOCAL_BACKUP_DIR/$HOST_BACKUP_FILENAME"
      docker exec "$CONTAINER_NAME" rm "$CONTAINER_BACKUP_PATH"
      rclone copy "$LOCAL_BACKUP_DIR/$HOST_BACKUP_FILENAME" "$RCLONE_REMOTE/$HOST_BACKUP_FILENAME"
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "${config.myConfig.username}";
    };
  };
}

{ config, lib, pkgs, pkgsUnstable, ... }:

{
  systemd.timers."backup-secrets" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily"; # Examples: daily, weekly, hourly, *-*-* 03:00:00
      Persistent = true; # Run missed jobs on next boot
      Unit = "backup-secrets.service";
    };
  };

  systemd.services."backup-secrets" = {
    path = with pkgs; [
      rclone
    ];
    script = ''
      set -eu
      SOURCE_DIR="/home/connor/.local/.secret"
      DEST_DIR="/zstore/data/records/db_backups/secrets"

      echo "Checking existing files in destination..."
      EXISTING_FILES=$(find "$DEST_DIR" -maxdepth 1 -type f -printf "%f\n" 2>/dev/null || true)

      find "$SOURCE_DIR" -maxdepth 1 -type f | while read -r SOURCE_FILE; do
        FILENAME=$(basename "$SOURCE_FILE")

        if echo "$EXISTING_FILES" | grep -Fxq "$FILENAME"; then
          echo "Skipping $FILENAME (already exists in destination)"
        else
          echo "Copying $FILENAME..."
          cp "$SOURCE_FILE" "$DEST_DIR/"
          if [ $? -eq 0 ]; then
            echo "Successfully copied $FILENAME"
          else
            echo "Error copying $FILENAME"
          fi
        fi
      done

      rclone copy "$SOURCE_DIR" dropbox_enc:db_backups/secrets --ignore-existing

      echo "Backup operation completed."
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "${config.myConfig.username}";
    };
  };
}

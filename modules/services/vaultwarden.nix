{ config, pkgs, pkgsUnstable, ... }:

let
  backupScript = pkgs.writeShellScript "backup-vaultwarden" ''
    set -eu
    PATH="/run/wrappers/bin:$PATH"

    # Function to safely stop vaultwarden with retries
    stop_vaultwarden() {
      echo "Attempting to stop vaultwarden service..."

      # Check if service is already stopped
      if ! systemctl is-active --quiet vaultwarden.service; then
        echo "vaultwarden.service is already stopped"
        return 0
      fi

      # Try to stop the service with timeout
      if timeout 10 systemctl stop vaultwarden.service; then
        echo "vaultwarden.service stopped successfully"
        return 0
      else
        echo "Failed to stop vaultwarden.service within timeout"
        return 1
      fi
    }

    # Function to safely start vaultwarden
    start_vaultwarden() {
      echo "Starting vaultwarden service..."
      if systemctl start vaultwarden.service; then
        echo "vaultwarden.service started successfully"
      else
        echo "Warning: Failed to start vaultwarden.service"
        return 1
      fi
    }

    # Trap to ensure we always try to restart vaultwarden
    cleanup() {
      echo "Backup process interrupted, attempting to restart vaultwarden..."
      start_vaultwarden || true
    }
    trap cleanup EXIT INT TERM

    # Stop vaultwarden
    if ! stop_vaultwarden; then
      echo "Error: Could not stop vaultwarden service, aborting backup"
      exit 1
    fi

    SOURCE_DB="/var/lib/vaultwarden/data/db.sqlite3"
    BACKUP_DB="/var/lib/vaultwarden/backups/$(date +%y%m%d)-db.sqlite"
    BACKUP_FILENAME="$(date +%y%m%d)-vaultwarden.tar.gz"
    BACKUP_FILE="/tmp/$BACKUP_FILENAME"
    ZSTORE_PATH="/zstore/data/records/db_backups/vaultwarden"

    # Perform the backup
    echo "Creating database backup..."
    sqlite3 "$SOURCE_DB" ".backup '$BACKUP_DB'"

    echo "Creating tar archive..."
    tar -czpf "$BACKUP_FILE" -C /var/lib vaultwarden

    echo "Copying to zstore..."
    cp "$BACKUP_FILE" "$ZSTORE_PATH/"
    chown 1000:100 "$ZSTORE_PATH/$BACKUP_FILENAME"

    echo "Uploading to cloud storage..."
    sudo -u ${config.myConfig.username} rclone copy "$ZSTORE_PATH/$BACKUP_FILENAME" gdrive_enc:db_backups/vaultwarden

    echo "Cleaning up temporary files..."
    rm "$BACKUP_FILE"

    # Start vaultwarden back up
    start_vaultwarden

    # Clear the trap since we succeeded
    trap - EXIT INT TERM

    echo "Backup completed successfully"
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
      systemd
    ];
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      ExecStart = "${backupScript}";
    };
  };
}

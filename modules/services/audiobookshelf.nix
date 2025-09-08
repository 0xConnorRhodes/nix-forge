{ config, lib, pkgs, pkgsUnstable, ... }:

{
  services.audiobookshelf = {
    enable = true;
    package = pkgsUnstable.audiobookshelf;
    host = "127.0.0.1";
    port = 61793;
  };

  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "audiobookshelf-backup" ''
      #!/bin/bash

      SOURCE_DIR="/var/lib/audiobookshelf/metadata/backups"
      DEST_DIR="/mnt/zdata/records/db_backups/audiobookshelf"

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

      echo "Backup operation completed."
    '')
  ];
}

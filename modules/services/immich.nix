{ config, lib, pkgs, pkgsUnstable, ... }:

{
  # services.immich = {
  #   enable = true;
  #   package = pkgsUnstable.immich;
  #   host = "127.0.0.1";
  #   port = 4312;
  #   user = config.myConfig.username;
  # };

  systemd.timers."immich-backup-docker" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily"; # Examples: daily, weekly, hourly, *-*-* 03:00:00
      Persistent = true; # Run missed jobs on next boot
      Unit = "immich-backup-docker.service";
    };
  };

  systemd.services."immich-backup-docker" = {
    path = with pkgs; [
      docker
      gnutar
      gzip
      coreutils
      rclone
    ];
    script = ''
      set -e
      PATH="/run/wrappers/bin:$PATH"
      BACKUP_FILE="$(date +%y%m%d)-immich-db-backup.tar.gz"

      docker compose -f /home/connor/code/infra/immich/compose.yml down
      sudo tar -czpf /tmp/$BACKUP_FILE -C /home/connor/.local/docker_data immich
      sudo chown connor:users /tmp/$BACKUP_FILE
      mv /tmp/$BACKUP_FILE /zstore/data/records/db_backups/immich
      rclone copy /zstore/data/records/db_backups/immich dropbox_enc:db_backups/immich --ignore-existing
      docker compose -f /home/connor/code/infra/immich/compose.yml up -d
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "${config.myConfig.username}";
    };
  };
}

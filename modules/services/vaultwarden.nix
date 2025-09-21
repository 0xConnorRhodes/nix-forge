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
  #     gnutar
  #     gzip
  #   ];
  #   # TODO: write a shell script outside of systemd and get it working. then troubleshoot why it won't run in systemd with claude
  #   script = ''
  #     set -eu
  #     PATH="/run/wrappers/bin:$PATH"
  #     sudo systemctl stop vaultwarden.service
  #     # stop service
  #     # .backup database to /var/lib/vaultwarden/backups
  #     # tar the whole thing to /tmp then copy to zstore and rclone do db_enc
  #     sleep 5
  #     systemctl status vaultwarden.service
  #     sleep 5
  #     sudo systemctl start vaultwarden.service
  #   '';
  #   serviceConfig = {
  #     Type = "oneshot";
  #     User = "${config.myConfig.username}";
  #   };
  # };
}

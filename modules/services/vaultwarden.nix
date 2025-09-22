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
    # script = ''
    #   set -eu
    #   PATH="/run/wrappers/bin:$PATH"
    #   sudo sqlite3 /var/lib/vaultwarden/data/db.sqlite3 ".backup '/var/lib/vaultwarden/backups/$(date +%y%m%d)-db.sqlite'"
    #   # TODO: tar the whole thing to /tmp then copy to zstore and rclone do db_enc
    # '';
    serviceConfig = {
      Type = "oneshot";
      # User = "${config.myConfig.username}";
      User = "root";
      ExecStartPre = "${pkgs.systemd}/bin/systemctl stop vaultwarden.service";
      ExecStart = "${pkgs.bash}/bin/bash -c 'echo Hello from Bash on NixOS'";
      ExecStartPost = "${pkgs.systemd}/bin/systemctl start vaultwarden.service";


      # ExecStart = ''
      #   ${pkgs.bash}/bin/bash -c "
      #   set -eu
      #   PATH=\"/run/wrappers/bin:$PATH\"
      #   echo $PATH
      #   # sudo sqlite3 /var/lib/vaultwarden/data/db.sqlite3 ".backup '/var/lib/vaultwarden/backups/$(date +%y%m%d)-db.sqlite'"
      #   # # TODO: tar the whole thing to /tmp then copy to zstore and rclone do db_enc
      #   "
      # '';
    };
  };
}

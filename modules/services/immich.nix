{ config, lib, pkgs, pkgsUnstable, ... }:

{
  services.immich = {
    enable = true;
    package = pkgsUnstable.immich;
    host = "127.0.0.1";
    port = 4312;
    user = config.myConfig.username;
  };

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
    ];
    script = ''
      set -e
      PATH="/run/wrappers/bin:$PATH"
      docker compose -f /home/connor/code/infra/immich/compose.yml down
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "${config.myConfig.username}";
    };
  };
}

{ config, lib, pkgs, ... }:
let
  user = config.myConfig.username;
in
{
  systemd.services."podserve" = {
    description = "Podserve";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    path = with pkgs; [
      uv
    ];

    script = ''
      set -eu
      cd /home/${user}/code/tools/web/podserve
      SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt uv run server.py
    '';

    serviceConfig = {
      Type = "simple";
      User = user;
      WorkingDirectory = "/home/${user}/code/tools/web/podserve";
      Restart = "always";
      RestartSec = "10";
    };
  };

  # restart nightly to download new episodes
  systemd.timers."podserve-restart" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 02:00:00";
      Persistent = true;
    };
  };

  systemd.services."podserve-restart" = {
    script = "${pkgs.systemd}/bin/systemctl restart podserve.service";
    serviceConfig.Type = "oneshot";
  };
}

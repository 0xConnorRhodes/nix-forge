{ config, lib, pkgs, ... }:
let
  user = config.myConfig.username;
in
{
  systemd.services."web-tools" = {
    description = "Flask web tools via Gunicorn";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    path = with pkgs; [
      uv
    ];

    script = ''
      set -eu
      cd /home/${user}/code/tools/flask_apps
      uv run gunicorn --bind 127.0.0.1:4419 "server:application"
    '';

    serviceConfig = {
      Type = "simple";
      User = user;
      WorkingDirectory = "/home/${user}/code/tools/flask_apps";
      Restart = "always";
      RestartSec = "10";
    };
  };
}

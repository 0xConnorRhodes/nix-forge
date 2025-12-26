{ config, lib, pkgs, secrets, ... }:
let
  user = config.myConfig.username;
in
{
  systemd.services."api-connorrhodes-com" = {
    description = "FastAPI server for api.connorrhodes.com";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    path = with pkgs; [
      uv
    ];

    script = ''
      set -eu
      cd /home/${user}/code/api-connorrhodes-com
      uv run uvicorn main:app --host 127.0.0.1 --port 62521
    '';

    serviceConfig = {
      Type = "simple";
      User = user;
      WorkingDirectory = "/home/${user}/code/api-connorrhodes-com";
      Restart = "always";
      RestartSec = "10";
      Environment = "API_SERVER_KEY=${secrets.apiServerKey}";
    };
  };
}

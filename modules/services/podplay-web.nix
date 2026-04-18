{ config, lib, pkgs, ... }:
let
  user = config.myConfig.username;
in
{
  systemd.services."podplay-web" = {
    description = "Podplay web podcast player";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    path = with pkgs; [
      uv
    ];

    script = ''
      set -eu
      cd /home/${user}/code/tools/web/podplay-web
      uv run python app.py
    '';

    serviceConfig = {
      Type = "simple";
      User = user;
      WorkingDirectory = "/home/${user}/code/tools/web/podplay-web";
      Restart = "always";
      RestartSec = "10";
    };
  };
}

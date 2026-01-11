{ config, lib, pkgs, ... }:
let
  user = config.myConfig.username;
in
{
  # DumbTerm web-based terminal service
  systemd.services.dumbterm = {
    description = "DumbTerm Web-based Terminal Application";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    path = with pkgs; [
      nodejs
      bash
    ];

    script = ''
      set -eu
      cd /home/connor/code/DumbTerm
      npm start
    '';

    serviceConfig = {
      Type = "simple";
      User = user;
      WorkingDirectory = "/home/connor/code/DumbTerm";
      Restart = "always";
      RestartSec = "10";

      Environment = [
        "PORT=3002"
        "NODE_ENV=production"
        "DEBUG=TRUE"
        "SITE_TITLE=DumbTerm"
        "BASE_URL=http://localhost:3002"
        "DUMBTERM_PIN="
        "LOCKOUT_TIME="
        "ALLOWED_ORIGINS="
      ];
    };
  };
}

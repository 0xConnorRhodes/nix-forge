{ config, lib, pkgs, ... }:
let
  user = config.myConfig.username;

  printWebFormPython = pkgs.python3.withPackages (pythonPackages: with pythonPackages; [
    flask
    pypdf2
    werkzeug
  ]);
in
{
  # Print Web Form Flask service
  systemd.services."print-web-form" = {
    description = "Print Web Form Flask Application";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    script = ''
      set -eu
      cd /home/connor/code/print-web-form
      ${printWebFormPython}/bin/python app.py
    '';

    serviceConfig = {
      Type = "simple";
      User = user;
      WorkingDirectory = "/home/connor/code/print-web-form";
      Restart = "always";
      RestartSec = "10";

      Environment = [
        "FLASK_APP=app.py"
        "FLASK_ENV=production"
      ];
    };
  };
}

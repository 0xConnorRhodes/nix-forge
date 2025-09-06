{ config, lib, pkgs, ... }:
let
  user = config.myConfig.username;
  workingDir = "${config.myConfig.homeDir}/code/sqlite-backup";
  cronPython = pkgs.python3.withPackages (ps: with ps; [
  ]);
in
{
  # Run script to backup, dump, and store the contents of databases
  # (currently supports sqlite)

  # The systemd timer definition
  systemd.timers."sqlite-backup" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = false;
      Unit = "sqlite-backup.service";
    };
  };

  # The systemd service that the timer triggers
  systemd.services."sqlite-backup" = {
    script = ''
      set -eu
      cronPython/bin/python3 ${workingDir}/main.py
    '';
    serviceConfig = {
      Type = "oneshot";
      User = user;
      WorkingDirectory = workingDir;
    };
  };
}

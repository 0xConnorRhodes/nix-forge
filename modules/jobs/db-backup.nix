{ config, pkgs, ... }:
let
  user = config.myConfig.username;
  workingDir = "${config.myConfig.homeDir}/code/sqlite-backup";
  cronPython = pkgs.python3.withPackages (ps: with ps; [
    # add non stdlib packages here
  ]);
in
{
  # ... timer definition ...
  systemd.user.timers."sqlite-backup" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = false;
      Unit = "sqlite-backup.service";
    };
  };

  # The systemd user service that the timer triggers
  systemd.user.services."sqlite-backup" = {
    script = ''
      set -eu
      # Add the system's wrapper path to the PATH environment variable, needed for
      export PATH="/run/wrappers/bin:${pkgs.coreutils}/bin:${pkgs.rclone}/bin:${pkgs.sqlite}/bin"

      # Execute the python script
      ${cronPython}/bin/python3 ${workingDir}/main.py
    '';
    serviceConfig = {
      Type = "oneshot";
      WorkingDirectory = workingDir;
    };
  };
}

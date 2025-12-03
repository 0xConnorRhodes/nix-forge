{ config, lib, pkgs, ... }:
let
  user = config.myConfig.username;
in
{
# transcode music library
  systemd.timers."transcode-musiclibrary" = {
    wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "02:00:00";
        Persistent = true;
        Unit = "transcode-musiclibrary.service"; }; };
  systemd.services."transcode-musiclibrary" = {
    script = ''
      set -eu
      export PATH="${pkgs.uv}/bin:/run/current-system/sw/bin:$PATH"
      /home/${user}/code/scripts/cron/transcode-musiclibrary
    '';
    serviceConfig = {
      Type = "oneshot";
      User = user;
      WorkingDirectory = "/home/${user}/code/scripts/cron"; }; };
}
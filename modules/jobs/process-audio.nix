{ config, lib, pkgs, ... }:
let
  user = config.myConfig.username;
  pythonEnv = pkgs.python3.withPackages (p: [ p.pyyaml ]);
in
{
# transcode music library
  systemd.timers."transcode-music" = {
    wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "02:00:00";
        Persistent = true;
        Unit = "transcode-music.service"; }; };
  systemd.services."transcode-music" = {
    script = ''
      set -eu
      /home/${user}/.local/bin/transcode-music
    '';
    serviceConfig = {
      Type = "oneshot";
      User = user; }; };

# auto process audio
  systemd.timers."auto-process-audio" = {
    wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "02:00:00";
        Persistent = true;
        Unit = "auto-process-audio.service"; }; };
  systemd.services."auto-process-audio" = {
    script = ''
      set -eu
      export PATH="/home/${user}/.local/bin:/run/current-system/sw/bin:$PATH"
      ${pythonEnv}/bin/python3 /home/${user}/code/process-audio/auto-process-audio.py
    '';
    serviceConfig = {
      Type = "oneshot";
      User = user;
      WorkingDirectory = "/home/${user}/code/process-audio"; }; };
}

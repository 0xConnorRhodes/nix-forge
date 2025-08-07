{ config, lib, pkgs, ... }:
let
  user = config.myConfig.username;
  cronPython = pkgs.python3.withPackages (pythonPackages: with pythonPackages; [
    pyaml
    feedparser
  ]);
in
{
  systemd.timers."monitor-podcasts" = {
    wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "*:0/5"; # every 5m
        Persistent = true;
        Unit = "monitor-podcasts.service"; }; };
  systemd.services."monitor-podcasts" = {
    script = ''
      set -eu
      ${cronPython}/bin/python3 /home/connor/code/scripts/cron/monitor_podcast_feeds.py
    '';
    serviceConfig = {
      Type = "oneshot";
      User = user;
      WorkingDirectory = "/home/connor/code/scripts/cron";
      Environment = "PATH=$PATH"; }; };
}

{ config, lib, pkgs, ... }:
let
  user = config.myConfig.username;
  codeDir = "/home/${user}/code";

  cronPython = pkgs.python3.withPackages (pythonPackages: with pythonPackages; [
    jinja2
  ]);
in
{
# create daily note
  systemd.timers."create-daily-note" = {
    wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "03:00:00";
        Persistent = true;
        Unit = "create-daily-note.service"; }; };
  systemd.services."create-daily-note" = {
    script = ''
      set -eu
      ${cronPython}/bin/python3 /home/connor/code/scripts/cron/create_daily_note.py
    '';
    serviceConfig = {
      Type = "oneshot";
      User = user;
      WorkingDirectory = "/home/connor/code/scripts/cron";
      Environment = "PATH=${pkgs.iputils}/bin:$PATH"; }; };

# create md food log
  systemd.timers."create-foodlog" = {
    wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "03:10:00";
        Persistent = true;
        Unit = "create-foodlog.service"; }; };
  systemd.services."create-foodlog" = {
    script = ''
      set -eu
      ${pkgs.uv}/bin/uv run ${codeDir}/food-log/create_cal_budget.py
    '';
    serviceConfig = {
      Type = "oneshot";
      User = user;
      WorkingDirectory = "${codeDir}/food-log"; }; };

# bump index link to daily note
  systemd.timers."bump-index-dn-link" = {
    wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "04:00:00";
        Persistent = true;
        Unit = "bump-index-dn-link.service"; }; };
  systemd.services."bump-index-dn-link" = {
    script = ''
      set -eu
      ${pkgs.ruby}/bin/ruby /home/connor/code/scripts/cron/bump_index_daily_note_link.rb
    '';
    serviceConfig = {
      Type = "oneshot";
      User = user;
      WorkingDirectory = "/home/connor/code/scripts/cron"; }; };

# note automations nightly cleanup
  systemd.timers."note-automations-cron" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "02:00:00";
      Persistent = true;
      Unit = "note-automations-cron.service"; }; };
  systemd.services."note-automations-cron" = {
    script = ''
      set -eu
      ${pkgs.python3}/bin/python3 /home/connor/code/note_automations/scripts/cron.py
    '';
    serviceConfig = {
      Type = "oneshot";
      User = user;
      WorkingDirectory = "/home/connor/code/note_automations/scripts"; }; };

# attachments to s2 sync
  systemd.timers."attachments-to-s2" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "02:10:00";
      Persistent = true;
      Unit = "attachments-to-s2.service"; }; };
  systemd.services."attachments-to-s2" = {
    script = ''
      set -eu
      ${pkgs.python3}/bin/python3 /home/connor/code/note_automations/scripts/attachments_to_s2.py
    '';
    serviceConfig = {
      Type = "oneshot";
      User = user;
      WorkingDirectory = "/home/connor/code/note_automations/scripts"; }; };
}

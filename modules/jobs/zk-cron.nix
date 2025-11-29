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

# load todays tasks into daily note
  systemd.timers."load-todays-tasks" = {
    wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "03:05:00";
        Persistent = true;
        Unit = "load-todays-tasks.service"; }; };
  systemd.services."load-todays-tasks" = {
    script = ''
      set -eu
      ${pkgs.ruby}/bin/ruby /home/connor/code/scripts/cron/load_todays_tasks.rb
    '';
    serviceConfig = {
      Type = "oneshot";
      User = user;
      WorkingDirectory = "/home/connor/code/scripts/cron";
      Environment = "PATH=${pkgs.ripgrep}/bin:$PATH"; }; };

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
        OnCalendar = "03:00:00";
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

# build note lists (vaccounts, etc)
  systemd.timers."build-note-lists" = {
    wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "03:00:00";
        Persistent = true;
        Unit = "build-note-lists.service"; }; };
  systemd.services."build-note-lists" = {
    script = ''
      set -eu
      ${pkgs.ruby}/bin/ruby /home/connor/code/scripts/cron/build_note_lists.rb
    '';
    serviceConfig = {
      Type = "oneshot";
      User = user;
      WorkingDirectory = "/home/connor/code/scripts/cron";
      Environment = "PATH=${pkgs.ripgrep}/bin:$PATH"; }; };

# link notes
  systemd.timers."link-notes" = {
    wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "*:*:00";
        Persistent = true;
        Unit = "link-notes.service"; }; };
  systemd.services."link-notes" = {
    script = ''
      set -eu
      export PATH="/home/${user}/.nix-profile/bin:$PATH"
      /home/${user}/code/scripts/pkm/link-notes
    '';
    serviceConfig = {
      Type = "oneshot";
      User = user;
      WorkingDirectory = "/home/${user}/code/scripts/pkm"; }; };

# update zk
  systemd.timers."update-zk" = {
    wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "01:00:00";
        Persistent = true;
        Unit = "update-zk.service"; }; };
  systemd.services."update-zk" = {
    script = ''
      set -eu
      export PATH="/home/${user}/.nix-profile/bin:$PATH"
      /home/${user}/code/scripts/pkm/update-zk
    '';
    serviceConfig = {
      Type = "oneshot";
      User = user;
      WorkingDirectory = "/home/${user}/code/scripts/pkm"; }; };
}

{ config, lib, pkgs, ... }:

{

# backup filenames on cache drive
  systemd.timers."backup-scary-filenames" = {
    wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "02:00:00";
        Persistent = true;
        Unit = "backup-scary-filenames.service"; }; };
  systemd.services."backup-scary-filenames" = {
    script = ''
      set -eu
      ${pkgs.ruby}/bin/ruby /home/connor/code/scripts/cron/backups/cache_drive_file_list.rb
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "connor";
      WorkingDirectory = "/home/connor/code/scripts/cron/backups";
      Environment = "PATH=${pkgs.rclone}/bin:${pkgs.fd}/bin:$PATH"; }; };

  systemd.timers."backup-papers" = {
    wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "02:10:00";
        Persistent = true;
        Unit = "backup-papers.service"; }; };
  systemd.services."backup-papers" = {
    script = ''
      set -eu
      ${pkgs.dash}/bin/dash /home/connor/code/scripts/cron/backups/back_up_papers.sh
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "connor";
      WorkingDirectory = "/home/connor/code/scripts/cron/backups";
      Environment = "PATH=${pkgs.rclone}/bin:${pkgs.rsync}/bin:$PATH"; }; };

  systemd.timers."nix-collect-garbage" = {
    wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "Thu *-*-* 00:00:00";
        Persistent = true;
        Unit = "nix-collect-garbage.service"; }; };
  systemd.services."nix-collect-garbage" = {
    script = ''
      set -eu
      ${pkgs.nix}/bin/nix-collect-garbage -d
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root"; }; };

}

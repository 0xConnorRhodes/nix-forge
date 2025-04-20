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
      ${pkgs.ruby}/bin/ruby /home/connor/code/cron-scripts/backups/cache_drive_file_list.rb
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "connor";
      WorkingDirectory = "/home/connor/code/cron-scripts/backups";
      Environment = "PATH=${pkgs.rclone}/bin:${pkgs.fd}/bin:$PATH"; }; };

}

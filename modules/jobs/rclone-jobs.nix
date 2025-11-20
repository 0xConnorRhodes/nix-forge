{ config, pkgs, ... }:

{
  systemd.timers."move-phone-voice-recordings" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "hourly"; # Examples: daily, weekly, hourly, *-*-* 03:00:00
      Persistent = true; # Run missed jobs on next boot
      Unit = "move-phone-voice-recordings.service";
    };
  };

  systemd.services."move-phone-voice-recordings" = {
    path = with pkgs; [
      rclone
    ];
    script = ''
      set -eu
      PATH="/run/wrappers/bin:$PATH"
      rclone move "gdrive:Easy Voice Recorder" "/scary/files/share/audio_dispatch"
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "${config.myConfig.username}";
    };
  };
}

{ config, pkgs, ... }:

{
  systemd.timers."move-phone-voice-recordings" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*:0/5"; # Run every 5 minutes
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

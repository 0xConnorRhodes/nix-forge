{ config, lib, pkgs, inputs, ... }:
let
  cronRuby = pkgs.ruby.withPackages (ruby-pkgs: with ruby-pkgs; [
    dotenv
  ]);
in
{
  # sync notes (1m interval)
  systemd.timers."sync-notes" = {
    wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "1min";
        OnUnitActiveSec = "1min";
        Persistent = true;
        Unit = "sync-notes.service"; }; };
  systemd.services."sync-notes" = {
    script = ''
      set -eu
      ${cronRuby}/bin/ruby /home/connor/code/scripts/bin/ns
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "connor";
      WorkingDirectory = "/home/connor/code/scripts";
      Environment = "PATH=${pkgs.iputils}/bin:${pkgs.git}/bin:${pkgs.openssh}/bin:$PATH"; }; };
}

{ config, lib, pkgs, inputs, ... }:
let
  user = config.myConfig.username;
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
      export PATH="/home/${user}/.nix-profile/bin:/run/current-system/sw/bin:$PATH"
      ${cronRuby}/bin/ruby /home/${user}/code/scripts/bin/ns
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "${user}";
      WorkingDirectory = "/home/${user}/code/scripts";
      Environment = "PATH=${pkgs.iputils}/bin:${pkgs.git}/bin:${pkgs.openssh}/bin:$PATH"; }; };
}

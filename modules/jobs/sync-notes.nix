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

  # sync skills repo (1m interval)
  systemd.timers."sync-skills" = {
    wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "1min";
        OnUnitActiveSec = "1min";
        Persistent = true;
        Unit = "sync-skills.service"; }; };
  systemd.services."sync-skills" = {
    script = ''
      set -eu
      cd /home/${user}/notes/skills
      ${pkgs.git}/bin/git pull
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "${user}";
      Environment = "PATH=${pkgs.git}/bin:${pkgs.openssh}/bin:$PATH"; }; };
}

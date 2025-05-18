# { config, lib, pkgs, inputs, secrets, ... }: 
{ config, lib, pkgs, inputs, ... }:
let
  cronRuby = pkgs.ruby.withPackages (ruby-pkgs: with ruby-pkgs; [
    dotenv
  ]);
in
{
  # set path for launchd scripts to include nix and homebrew binaries
  # may need to run interactively on new machine setup
  system.activationScripts.text = ''
    launchctl config user path /opt/homebrew/bin:${config.myConfig.homeDir}/.nix-profile/bin:/usr/bin:/bin:/usr/sbin:/sbin
  '';

  launchd.user.agents = {
    sync-notes = {
      command = "${cronRuby}/bin/ruby /Users/connor.rhodes/code/scripts/bin/ns";
      serviceConfig = {
        RunAtLoad = true;
        StartInterval = 60;
        StandardOutPath = "/tmp/sync-notes.out.log";
        StandardErrorPath = "/tmp/sync-notes.err.log";
      };
    };
  };
}

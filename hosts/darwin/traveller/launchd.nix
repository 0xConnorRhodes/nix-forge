# { config, lib, pkgs, inputs, secrets, ... }: 
{ config, lib, pkgs, inputs, ... }:
let
  cronRuby = pkgs.ruby.withPackages (ruby-pkgs: with ruby-pkgs; [
    dotenv
  ]);
in
{
  launchd.user.agents = {
    sync-notes = {
      command = "${cronRuby}/bin/ruby /Users/connor.rhodes/code/scripts/ns";
      serviceConfig = {
        RunAtLoad = true;
        StartInterval = 60;
        StandardOutPath = "/tmp/sync-notes.out.log";
        StandardErrorPath = "/tmp/sync-notes.err.log";
      };
    };
  };
}
{ config, lib, pkgs, ... }:

let
  port = 38158;
  spaceDir = "${config.myConfig.homeDir}/code/skilstak/markdown";
in
{
  systemd.services.study-notes = {
    description = "Study Notes (Silverbullet)";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    preStart = "chmod -R g+rw '${spaceDir}'";
    serviceConfig = {
      Type = "simple";
      User = config.myConfig.username;
      Group = "users";
      ExecStart = "${lib.getExe pkgs.silverbullet} --port ${toString port} --hostname 127.0.0.1 '${spaceDir}'";
      Restart = "on-failure";
    };
  };

  systemd.tmpfiles.settings."study-notes" = {
    "${spaceDir}"."d" = {
      mode = "0775";
      user = config.myConfig.username;
      group = "users";
    };
  };
}

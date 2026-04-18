{ config, pkgs, ... }:

let
  src = pkgs.fetchFromGitHub {
    owner = "kd2org";
    repo = "opodsync";
    rev = "0.5.2";
    hash = "sha256-pdruIKmEDgcpxaPP0yZRzMDYTLLh9UZoG+UWkfvebcs=";
  };

  dataDir = "/var/lib/opodsync";

  configLocalPhp = pkgs.writeText "config.local.php" ''
    <?php
    namespace OPodSync;
    const TITLE = 'oPodSync';
    const BASE_URL = 'https://podsync.connorrhodes.com/';
    const ERRORS_SHOW = false;
    const ENABLE_SUBSCRIPTIONS = false;
  '';

  phpWithExt = pkgs.php82.withExtensions ({ all, ... }: [
    all.sqlite3
    all.mbstring
    all.session
  ]);
in
{
  systemd.services.opodsync = {
    enable = true;

    path = [ phpWithExt ];

    preStart = ''
      mkdir -p ${dataDir}/data
      if [ ! -f ${dataDir}/data/config.local.php ]; then
        cp ${configLocalPhp} ${dataDir}/data/config.local.php
      fi
    '';

    serviceConfig = {
      SyslogIdentifier = "opodsync";
      ExecStart = "${phpWithExt}/bin/php -S 127.0.0.1:29379 -t ${src}/server ${src}/server/index.php";
      Environment = [
        "DATA_ROOT=${dataDir}/data"
      ];
      Restart = "always";
      User = config.myConfig.username;
      Group = "users";
      WorkingDirectory = dataDir;
      StateDirectory = "opodsync";
      MemoryMax = "50%";
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      RestrictNamespaces = true;
      RestrictRealtime = true;
    };

    wantedBy = [ "multi-user.target" ];
  };
}

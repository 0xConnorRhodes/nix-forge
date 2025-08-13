{ config, pkgs, ... }:
let
  copypartyDir = "${config.myConfig.homeDir}/code/infra/priv/copyparty";

  customPython = pkgs.python3.withPackages (pythonPackages: with pythonPackages; [
    pyvips # used for image thumbnails
  ]);
in
{
  systemd.services.copyparty = {
    enable = true;

    serviceConfig = {
      SyslogIdentifier = "copyparty";

      ExecStart = "${customPython}/bin/python3 ${copypartyDir}/copyparty-sfx.py -c ${copypartyDir}/conf.conf";
      Restart = "always";
      User = config.myConfig.username;
      Group = "users";
      LogsDirectory = "copyparty";
      Environment = [
        "PATH=${pkgs.cfssl}/bin:$PATH"
        "PYTHONUNBUFFERED=x" # python output is not buffered, better for logging
      ];

      # -- Hardening Options --
      MemoryMax = "50%";
      MemorySwapMax = "50%";
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";
      RemoveIPC = true;
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
    };

    wantedBy = [ "multi-user.target" ];
  };
}

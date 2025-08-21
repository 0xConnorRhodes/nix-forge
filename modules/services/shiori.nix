{ config, pkgs, secrets, ... }:
{
  systemd.services.shiori = {
    enable = true;

    serviceConfig = {
      SyslogIdentifier = "shiori";

      ExecStart = "${pkgs.shiori}/bin/shiori server -a 127.0.0.1 -p 54699";
      Restart = "always";
      User = config.myConfig.username;
      Group = "users";
      LogsDirectory = "shiori";

      # configuration options: https://github.com/go-shiori/shiori/blob/master/docs/Configuration.md
      Environment = [
        "SHIORI_HTTP_SECRET_KEY=${secrets.shiori.secret_key}"
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

{ config, lib, pkgs, secrets, ... }:
{
  services.radicale = {
    enable = true;
    settings = {
      server = {
        hosts = [ "127.0.0.1:5232" ];
      };
      auth = {
        type = "htpasswd";
        htpasswd_filename = "/var/lib/radicale/htpasswd";
        htpasswd_encryption = "bcrypt";
      };
      storage = {
        filesystem_folder = "/var/lib/radicale/collections";
      };
    };
    rights = {
      public = {
        user = ".*";
        collection = "connor/public";
        permissions = "r";
      };
      root = {
        user = ".+";
        collection = "";
        permissions = "R";
      };
      principal = {
        user = ".+";
        collection = "{user}";
        permissions = "RW";
      };
      calendars = {
        user = ".+";
        collection = "{user}/[^/]+";
        permissions = "rw";
      };
    };
  };

  # Ensure Radicale state directory exists with proper permissions
  systemd.tmpfiles.rules = [
    "d /var/lib/radicale 0750 radicale radicale - -"
  ];

  # Generate htpasswd file with root privileges before radicale starts
  systemd.services.radicale-pre = {
    description = "Generate Radicale htpasswd file";
    wantedBy = [ "multi-user.target" ];
    before = [ "radicale.service" ];
    serviceConfig.Type = "oneshot";
    script = ''
      mkdir -p /var/lib/radicale
      if [ ! -f /var/lib/radicale/htpasswd ]; then
        ${pkgs.apacheHttpd}/bin/htpasswd -bcB /var/lib/radicale/htpasswd \
          "${secrets.radicale.username}" "${secrets.radicale.password}"
        chmod 640 /var/lib/radicale/htpasswd
        chown radicale:radicale /var/lib/radicale/htpasswd
      fi
    '';
  };
}

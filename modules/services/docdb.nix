{ config, pkgs, ... }:

let
  sopsFile = ./../../secrets.yaml;
  dataDir = "/var/lib/ferretdb";
in
{
  sops.secrets."mongodb/rootPassword" = {
    inherit sopsFile;
  };
  sops.secrets."mongodb/port" = {
    inherit sopsFile;
  };

  networking.firewall.allowedTCPPorts = [ 44162 ];

  systemd.services.ferretdb = {
    description = "FerretDB (MongoDB-compatible document database)";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    requires = [ "mongo-express-password.service" ];

    path = [ pkgs.ferretdb ];

    preStart = ''
      mkdir -p ${dataDir}
    '';

    script = ''
      PASSWORD=$(cat ${config.sops.secrets."mongodb/rootPassword".path})
      PORT=$(cat ${config.sops.secrets."mongodb/port".path})
      exec ferretdb \
        --handler=sqlite \
        --listen-addr=0.0.0.0:"$PORT" \
        --sqlite-url=file:${dataDir}/ \
        --test-enable-new-auth \
        --setup-database=admin \
        --setup-username=root \
        --setup-password="$PASSWORD" \
        --log-level=info \
        --mode=normal
    '';

    serviceConfig = {
      Type = "simple";
      Restart = "on-failure";
      StateDirectory = "ferretdb";
      WorkingDirectory = dataDir;
    };
  };

  systemd.services.mongo-express-password = {
    description = "Generate mongo-express env file with connection URL";
    before = [ "docker-mongo-express.service" ];
    requiredBy = [ "docker-mongo-express.service" ];

    script = ''
      mkdir -p /var/lib/mongo-express
      PASSWORD=$(cat ${config.sops.secrets."mongodb/rootPassword".path})
      PORT=$(cat ${config.sops.secrets."mongodb/port".path})
      cat > /var/lib/mongo-express/env <<EOF
      ME_CONFIG_MONGODB_URL=mongodb://root:$PASSWORD@host.docker.internal:$PORT/admin
      EOF
    '';

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  virtualisation.oci-containers.backend = "docker";
  virtualisation.oci-containers.containers.mongo-express = {
    image = "docker.io/mongo-express:latest";
    ports = [ "127.0.0.1:8081:8081" ];
    environment = {
      ME_CONFIG_BASICAUTH = "false";
    };
    environmentFiles = [ "/var/lib/mongo-express/env" ];
    extraOptions = [ "--add-host=host.docker.internal:host-gateway" ];
  };
}

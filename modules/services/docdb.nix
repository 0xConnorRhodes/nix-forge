{ config, lib, pkgs, ... }:

let
  sopsFile = ./../../secrets.yaml;
  dataDir = "/var/lib/ferretdb";
  backupDir = "/zstore/data/records/docdb_backups";
  debounceSeconds = 60;

  backupScript = pkgs.writeScript "docdb-backup.py" ''
    #!/usr/bin/env python3
    import sys
    import subprocess
    import hashlib
    from pathlib import Path
    sys.stdout.reconfigure(line_buffering=True)
    sys.stderr.reconfigure(line_buffering=True)
    from datetime import datetime
    from threading import Timer

    pending = {}


    def hash_file(path):
        h = hashlib.sha256()
        with open(path, "rb") as f:
            for chunk in iter(lambda: f.read(8192), b""):
                h.update(chunk)
        return h.hexdigest()


    def do_backup(db_name, watch_dir, backup_dir):
        source = Path(watch_dir) / f"{db_name}.sqlite"
        if not source.exists():
            return

        ts = datetime.now().strftime("%y%m%d-%H%M%S")
        db_backup_dir = Path(backup_dir) / db_name
        db_backup_dir.mkdir(parents=True, exist_ok=True)

        dest = db_backup_dir / f"{ts}_{db_name}.sqlite"

        result = subprocess.run(
            ["sqlite3", str(source), f".backup {dest}"],
            capture_output=True,
            text=True,
        )

        if result.returncode != 0:
            print(f"Backup failed for {db_name}: {result.stderr}", file=sys.stderr)
            if dest.exists():
                dest.unlink()
            return

        backups = sorted(db_backup_dir.glob(f"*_{db_name}.sqlite"))
        if len(backups) >= 2:
            prev_hash = hash_file(backups[-2])
            new_hash = hash_file(backups[-1])
            if prev_hash == new_hash:
                backups[-1].unlink()
                return

        print(f"Backed up {db_name} -> {dest}")


    def schedule_backup(db_name, watch_dir, backup_dir, debounce):
        if db_name in pending:
            pending[db_name].cancel()
        pending[db_name] = Timer(
            debounce, do_backup, args=(db_name, watch_dir, backup_dir)
        )
        pending[db_name].daemon = True
        pending[db_name].start()


    def main():
        watch_dir = sys.argv[1]
        backup_dir = sys.argv[2]
        debounce = int(sys.argv[3])

        for f in Path(watch_dir).glob("*.sqlite"):
            if f.name.endswith("-wal") or f.name.endswith("-shm"):
                continue
            db_name = f.stem
            schedule_backup(db_name, watch_dir, backup_dir, debounce)

        for line in sys.stdin:
            filename = line.strip()
            if not filename:
                continue
            if filename.endswith(".sqlite-wal"):
                db_name = filename[: -len(".sqlite-wal")]
                schedule_backup(db_name, watch_dir, backup_dir, debounce)
            elif filename.endswith(".sqlite") and not filename.endswith(("-wal", "-shm")):
                db_name = filename[: -len(".sqlite")]
                schedule_backup(db_name, watch_dir, backup_dir, debounce)


    if __name__ == "__main__":
        main()
  '';
in
{
  sops.secrets."mongodb/rootPassword" = {
    inherit sopsFile;
  };
  sops.secrets."mongodb/port" = {
    inherit sopsFile;
  };
  sops.secrets."mongodb/tlsCaCert" = {
    inherit sopsFile;
  };
  sops.secrets."mongodb/tlsServerCert" = {
    inherit sopsFile;
  };
  sops.secrets."mongodb/tlsServerKey" = {
    inherit sopsFile;
    mode = "0400";
  };

  networking.firewall.allowedTCPPorts = [ 44162 ];
  networking.firewall.interfaces.docker0.allowedTCPPorts = [ 27017 ];

  systemd.services.ferretdb = {
    description = "FerretDB (MongoDB-compatible document database)";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    requires = [ "mongo-express-password.service" ];

    path = [ pkgs.ferretdb ];

    preStart = ''
      mkdir -p ${dataDir}
    '';

    # Two listeners for the same backend:
    #   27017 (plain TCP, docker bridge only) — for mongo-express which can't do TLS with ferretdb v1.24
    #   44162 (TLS, all interfaces) — for external/remote connections requiring encryption
    script = ''
      PASSWORD=$(cat ${config.sops.secrets."mongodb/rootPassword".path})
      PORT=$(cat ${config.sops.secrets."mongodb/port".path})
      exec ferretdb \
        --handler=sqlite \
        --listen-addr=172.17.0.1:27017 \
        --listen-tls=0.0.0.0:"$PORT" \
        --listen-tls-cert-file=${config.sops.secrets."mongodb/tlsServerCert".path} \
        --listen-tls-key-file=${config.sops.secrets."mongodb/tlsServerKey".path} \
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
      ME_CONFIG_MONGODB_URL=mongodb://root:$PASSWORD@host.docker.internal:27017/admin
      EOF
    '';

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  systemd.services.docdb-backup = {
    description = "Event-driven FerretDB SQLite backup daemon";
    wantedBy = [ "multi-user.target" ];
    requires = [ "ferretdb.service" ];
    after = [ "ferretdb.service" ];

    path = with pkgs; [
      sqlite
      inotify-tools
      python3
    ];

    environment.TZ = "America/Chicago";

    script = ''
      exec inotifywait -m -e modify -e create --format '%f' ${dataDir} | \
        ${pkgs.python3}/bin/python3 ${backupScript} ${dataDir} ${backupDir} ${toString debounceSeconds}
    '';

    serviceConfig = {
      Type = "simple";
      Restart = "on-failure";
      RestartSec = "10";
      User = "root";
    };
  };

  systemd.tmpfiles.rules = [
    "d ${backupDir} 0755 root root -"
  ];

  virtualisation.oci-containers.backend = "docker";
  virtualisation.oci-containers.containers.mongo-express = {
    image = "docker.io/mongo-express:latest";
    ports = [ "127.0.0.1:8081:8081" ];
    environment = {
      ME_CONFIG_BASICAUTH = "false";
    };
    environmentFiles = [ "/var/lib/mongo-express/env" ];
    extraOptions = [
      "--add-host=host.docker.internal:host-gateway"
    ];
  };
}

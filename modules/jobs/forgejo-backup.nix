{ config, pkgs, secrets, ... }:

let
  backupScript = pkgs.writeText "forgejo-backup.py" ''
    #!/usr/bin/env python3
    import json, os, subprocess
    from pathlib import Path
    from urllib.request import Request, urlopen

    TOKEN = os.environ["FORGEJO_TOKEN"]
    BASE_URL = "https://git.connorrhodes.com"
    BACKUP_DIR = Path("/zstore/data/records/forgejo/repos")

    def get_all_repos():
        repos = []
        page = 1
        while True:
            url = f"{BASE_URL}/api/v1/user/repos?page={page}&limit=50"
            req = Request(url, headers={"Authorization": f"token {TOKEN}"})
            with urlopen(req) as resp:
                data = json.loads(resp.read())
            if not data:
                break
            repos.extend(data)
            page += 1
        return repos

    def backup_repo(full_name, ssh_url):
        repo_path = BACKUP_DIR / full_name
        if (repo_path / ".git").exists():
            print(f"  Pulling {full_name}...")
            subprocess.run(["git", "-C", str(repo_path), "pull"], check=True)
        else:
            repo_path.parent.mkdir(parents=True, exist_ok=True)
            print(f"  Cloning {full_name}...")
            subprocess.run(["git", "clone", ssh_url, str(repo_path)], check=True)

    print("Fetching repo list...")
    repos = get_all_repos()
    print(f"Found {len(repos)} repos")
    for repo in repos:
        backup_repo(repo["full_name"], repo["ssh_url"])
    print(f"Done. Backed up {len(repos)} repos to {BACKUP_DIR}")
  '';
in
{
  systemd.timers."forgejo-backup" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      Unit = "forgejo-backup.service";
    };
  };

  systemd.services."forgejo-backup" = {
    path = with pkgs; [
      git
      openssh
      python3
      rclone
    ];
    script = ''
      set -eu
      BACKUP_DIR="/zstore/data/records/forgejo/repos"
      FORGEJO_TOKEN="${secrets.forgejo.apiToken}" ${pkgs.python3}/bin/python3 ${backupScript}
      rclone sync "$BACKUP_DIR" gdrive_enc:forgejo/repos
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "${config.myConfig.username}";
    };
  };
}

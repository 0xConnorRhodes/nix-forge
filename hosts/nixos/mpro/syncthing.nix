{ pkgs, config, ... }:
let
  secrets = builtins.fromJSON (builtins.readFile ../../../secrets.json);
  guiPort = 42631;
in
{
  services.syncthing = {
    enable = true;
    user = config.myConfig.username;
    dataDir = "${config.myConfig.homeDir}/.local/syncthing";
    openDefaultPorts = true;
    key = "${config.myConfig.homeDir}/code/nix-forge/hosts/nixos/mpro/config/syncthing-key.pem";
    cert = "${config.myConfig.homeDir}/code/nix-forge/hosts/nixos/mpro/config/syncthing-cert.pem";
    #guiAddress = "${config.myConfig.tailscaleIp}:${toString guiPort}";
    guiAddress = "127.0.0.1:${toString guiPort}";
    settings = {
      gui = { 
        # disable built-in auth
        user = ""; 
        password = ""; 
      };
      devices = {
        "phone" = { id = secrets.syncthing.phone_id; };
      };
      folders = {
        "Notes" = {
          path = "${config.myConfig.homeDir}/notes"; # phone_path: internal/DCIM/notes
          devices = [ "phone" ];
        };
        "Audiobooks" = {
          path = "/scary/phone/audiobooks"; # phone_path: internal/Music/Audiobooks
          devices = [ "phone" ];
        };
        "Music Library" = {
          path = "/scary/phone/music_library"; # phone_path: internal/Music/music_library
          devices = [ "phone" ];
        };
        "Ebooks" = {
          path = "/scary/phone/ebooks"; # phone_path: internal/Books
          devices = [ "phone" ];
        };
      };
    };
  };
  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true"; # Don't create default ~/Sync folder
}
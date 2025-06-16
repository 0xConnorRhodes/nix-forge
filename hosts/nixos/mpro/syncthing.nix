{ pkgs, config, secrets, ... }:
let
  guiPort = 42631;
in
{
  services.syncthing = {
    enable = true;
    user = config.myConfig.username;
    dataDir = "${config.myConfig.homeDir}/.local/syncthing";
    openDefaultPorts = true;
    key = "${config.myConfig.homeDir}/code/infra/certs/syncthing/mpro/syncthing-key.pem";
    cert = "${config.myConfig.homeDir}/code/infra/certs/syncthing/mpro/syncthing-cert.pem";
    guiAddress = "127.0.0.1:${toString guiPort}";
    settings = {
      gui = {
        # disable built-in auth
        user = "";
        password = "";
        insecureSkipHostcheck = true; # breaks reverse-proxy redirection to localhost if enabled
      };
      devices = {
        "phone" = { id = secrets.syncthing.phone_id; };
      };
      folders = {
        "Notes" = {
          path = "${config.myConfig.homeDir}/code/notes"; # phone_path: internal/DCIM/notes
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
        "Movies" = {
          path = "/scary/phone/movies"; # phone_path: internal/Movies
          devices = [ "phone" ];
        };
      };
    };
  };
  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true"; # Don't create default ~/Sync folder
}

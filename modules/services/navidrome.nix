{ config, lib, pkgs, ... }:

{
  services.navidrome = {
    enable = true;
    openFirewall = true;
    settings = {
      Address = "127.0.0.1";
      #ReverseProxyWhitelist = "0.0.0.0/0";
      EnableUserEditing = false;
      Port = 15612;
      BaseUrl = "https://mus.connorrhodes.com";
      MusicFolder = "/scary/phone/music_library";
      DataDir = "/var/lib/navidrome";
      PlaylistsPath = "_playlists";
      DefaultPlaylistPublicVisibility = false;
      AutoImportPlaylists = true;

      DefaultTheme = "Catppuccin Macchiato";
      CoverArtPriority = "embedded"; # pull cover art from embedded file data
      DefaultUIVolume = 10; # out of 100
      Scanner.PurgeMissing = "always";

      EnableCoverAnimation = false;
      EnableDownloads = false;
      LastFM.Enabled = false;
      ListenBrainz.Enabled = false;
      Deezer.Enabled = false;
      EnableNowPlaying = false;
      SessionTimeout = "1h";
      SmartPlaylistRefreshDelay = "30s";
    };
  };
}

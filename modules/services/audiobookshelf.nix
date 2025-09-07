{ config, lib, pkgs, ... }:

{
  services.audiobookshelf = {
    enable = true;
    host = "127.0.0.1";
    port = 61793;
  };
}

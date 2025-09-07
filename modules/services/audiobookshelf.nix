{ config, lib, pkgs, pkgsUnstable, ... }:

{
  services.audiobookshelf = {
    enable = true;
    package = pkgsUnstable.audiobookshelf;
    host = "127.0.0.1";
    port = 61793;
  };
}

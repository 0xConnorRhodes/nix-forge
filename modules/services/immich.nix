{ config, lib, pkgs, pkgsUnstable, ... }:

{
  services.immich = {
    enable = true;
    package = pkgsUnstable.immich;
    host = "127.0.0.1";
    port = 4311;
    user = config.myConfig.username;
  };
}

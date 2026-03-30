{ config, lib, pkgs, ... }:

{
  services.forgejo = {
    enable = true;
    database.type = "sqlite3";
    settings = {
      server = {
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = 3200;
        DOMAIN = "git.connorrhodes.com";
        ROOT_URL = "https://git.connorrhodes.com";
        OFFLINE_MODE = true;
      };
      service = {
        DISABLE_REGISTRATION = true;
        DEFAULT_ALLOW_CREATE_ORGANIZATION = false;
        DEFAULT_ENABLE_TIMETRACKING = false;
        DEFAULT_PRIVATE = "private";
        FORCE_PRIVATE = true;
      };
    };
  };
}

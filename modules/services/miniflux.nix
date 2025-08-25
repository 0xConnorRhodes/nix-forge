{ config, pkgs, lib, ... }:

{
  services.miniflux = {
    enable = true;
    createDatabaseLocally = true;
    adminCredentialsFile = pkgs.writeText "miniflux-admin-credentials" ''
      ADMIN_USERNAME=admin
      ADMIN_PASSWORD=changeme123
    '';
    config = {
      LISTEN_ADDR = "127.0.0.1:25279";
      BASE_URL = "http://127.0.0.1:25279";
      CREATE_ADMIN = "1";
    };
  };
}

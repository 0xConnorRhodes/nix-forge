{ config, pkgs, lib, ... }:

{
  services.miniflux = {
    enable = true;
    createDatabaseLocally = true;
    # Provide dummy admin credentials file to satisfy NixOS module validation
    # even though CREATE_ADMIN is disabled
    adminCredentialsFile = pkgs.writeText "miniflux-dummy-admin-credentials" ''
      ADMIN_USERNAME=unused
      ADMIN_PASSWORD=unused
    '';
    config = {
      LISTEN_ADDR = "127.0.0.1:25279";
      BASE_URL = "http://127.0.0.1:25279";

      # Disable admin user creation explicitly
      CREATE_ADMIN = "0";

      # Enable auth proxy authentication
      AUTH_PROXY_USER_CREATION = "1";
      AUTH_PROXY_HEADER = "Remote-User";  # Common auth proxy header

      # Disable local authentication since we're using proxy auth
      DISABLE_LOCAL_AUTH = "1";
    };
  };
}

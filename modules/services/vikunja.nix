{
  lib,
  ...
}: {
  services.vikunja = {
    enable = true;
    frontendHostname = "tasks.connorrhodes.com";
    frontendScheme = "https";
    port = 15177;

    # Use SQLite database
    database = {
      type = "sqlite";
    };

    # Optional: Custom settings
    settings = {
      service = {
        interface = lib.mkForce "127.0.0.1:15177";
        timezone = "America/Chicago";
      };
      auth = {
        local.enabled = true;
      };
    };
  };

  # Configure firewall manually since there's no openFirewall option
  # networking.firewall.allowedTCPPorts = [ 15177 ];
}

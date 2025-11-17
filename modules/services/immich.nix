{ config, lib, pkgs, pkgsUnstable, ... }:

{
  services.immich = {
    enable = true;
    # Network configuration
    host = "0.0.0.0";  # Listen on all interfaces
    port = 2283;       # Default port
    openFirewall = true;

    # Media storage location
    mediaLocation = "/var/lib/immich";

    # Enable database (PostgreSQL with required extensions)
    database = {
      enable = true;
      createDB = true;
      name = "immich";
      user = "immich";
      host = "/run/postgresql";  # Use Unix socket for better security
      enableVectorChord = true;  # Enable for full-text search
      enableVectors = true;      # Keep pgvecto.rs for compatibility
    };

    # Enable Redis cache
    redis = {
      enable = true;
    };

    # Enable machine learning for face detection and object search
    machine-learning = {
      enable = true;
    };

    # Basic environment configuration
    environment = {
      # Set log level for debugging if needed
      # IMMICH_LOG_LEVEL = "verbose";
    };
  };
}

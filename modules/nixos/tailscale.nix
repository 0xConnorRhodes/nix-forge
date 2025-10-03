{ config, pkgs, pkgsUnstable, secrets, ... }:

{
  # Enable Tailscale with modern NixOS module configuration
  services.tailscale = {
    enable = true;
    # Use unstable package if needed
    #package = pkgsUnstable.tailscale;

    # Open firewall for Tailscale traffic
    openFirewall = true;

    # Enable routing features for exit node functionality
    # "server" enables IP forwarding for exit nodes and subnet routers
    # "both" would enable both client and server features
    useRoutingFeatures = "server";

    # Create auth key file for automatic authentication
    # This replaces the manual systemd service approach
    authKeyFile = pkgs.writeText "tailscale-authkey" secrets.tailscaleAuthKey;

    # Configure as exit node using extraSetFlags
    # This runs after the service starts and sets persistent configuration
    extraSetFlags = [
      "--advertise-exit-node"
    ];

    # # Additional flags for the 'tailscale up' command
    # # These are applied during initial authentication
    # extraUpFlags = [
    #   "--accept-routes"  # Accept subnet routes from other nodes
    #   "--ssh"           # Enable Tailscale SSH (optional)
    # ];

    # Optional: Additional daemon flags
    # extraDaemonFlags = [
    #   "--no-logs-no-support"  # Disable log streaming (more private)
    # ];
  };

  # Enable nftables for better firewall management
  networking.nftables.enable = true;

  # The module automatically handles:
  # - IP forwarding when useRoutingFeatures = "server"
  # - Firewall configuration when openFirewall = true
  # - Automatic authentication when authKeyFile is provided
  # - Service dependencies and startup order
}

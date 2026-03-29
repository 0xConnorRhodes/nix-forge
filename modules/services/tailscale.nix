{ config, pkgs, pkgsUnstable, secrets, lib, ... }:

{
  # Enable Tailscale with modern NixOS module configuration
  services.tailscale = {
    enable = true;
    # Use unstable package if needed
    #package = pkgsUnstable.tailscale;

    # Open firewall for Tailscale traffic
    openFirewall = true;

    # Enable routing features based on exit node configuration
    # "server" enables IP forwarding for exit nodes and subnet routers
    # "client" enables client-side routing features
    # "both" would enable both client and server features
    useRoutingFeatures = if config.myConfig.tailscale.isExitNode then "server" else "client";

    # Create auth key file for automatic authentication
    # This replaces the manual systemd service approach
    authKeyFile = pkgs.writeText "tailscale-authkey" secrets.tailscaleAuthKey;

    # Configure as exit node using extraSetFlags only if enabled for this host
    extraSetFlags = lib.optionals config.myConfig.tailscale.isExitNode [
      "--advertise-exit-node"
    ];

    # Additional flags for the 'tailscale up' command
    # These are applied during initial authentication
    extraUpFlags = [
      "--accept-routes"  # Accept subnet routes from other nodes
      "--ssh"           # Enable Tailscale SSH (optional)
    ];

    # Optional: Additional daemon flags
    # extraDaemonFlags = [
    #   "--no-logs-no-support"  # Disable log streaming (more private)
    # ];
  };

  # Enable nftables for better firewall management
  networking.nftables.enable = true;

  # The module automatically handles:
  # - IP forwarding when useRoutingFeatures = "server" (exit nodes)
  # - Firewall configuration when openFirewall = true
  # - Automatic authentication when authKeyFile is provided
  # - Service dependencies and startup order
}

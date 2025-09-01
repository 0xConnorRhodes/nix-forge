{ config, lib, pkgs, ... }:

{
  # Enable NFS server
  services.nfs.server.enable = true;

  # Configure exports - restrict to Tailscale network
  services.nfs.server.exports = ''
    /scary/share 100.64.0.0/10(rw,sync,no_subtree_check,all_squash,anonuid=1000,anongid=100)
  '';

  # Open firewall ports for NFS only on Tailscale interface
  networking.firewall.interfaces."tailscale0" = {
    allowedTCPPorts = [
      111   # portmapper
      2049  # nfsd
      4000  # lockd
      4001  # mountd
      4002  # statd
    ];

    allowedUDPPorts = [
      111   # portmapper
      2049  # nfsd
      4000  # lockd
      4001  # mountd
      4002  # statd
    ];
  };

  # Ensure the directory exists and has proper permissions
  systemd.tmpfiles.rules = [
    "d /scary/share 0755 ${config.myConfig.username} users -"
  ];

  # Enable required services
  services.rpcbind.enable = true;
}

{ config, lib, pkgs, ... }:

{
  # Enable NFS server
  services.nfs.server.enable = true;

  # Configure exports
  services.nfs.server.exports = ''
    /scary/share *(rw,sync,no_subtree_check,no_root_squash)
  '';

  # Open firewall ports for NFS
  networking.firewall.allowedTCPPorts = [
    111   # portmapper
    2049  # nfsd
    4000  # lockd
    4001  # mountd
    4002  # statd
  ];

  networking.firewall.allowedUDPPorts = [
    111   # portmapper
    2049  # nfsd
    4000  # lockd
    4001  # mountd
    4002  # statd
  ];

  # Ensure the directory exists and has proper permissions
  systemd.tmpfiles.rules = [
    "d /scary/share 0755 ${config.myConfig.username} users -"
  ];

  # Enable required services
  services.rpcbind.enable = true;
}

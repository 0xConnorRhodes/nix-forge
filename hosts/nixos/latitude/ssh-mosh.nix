{ config, ... }:

{
    # ssh and mosh only over tailscale
    programs.mosh.enable = true;
    programs.mosh.openFirewall = false;
    services.openssh = {
      enable = true;
      startWhenNeeded = true;
      openFirewall = false;
      ports = [ 22 ];
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
    networking.firewall.enable = true;
    networking.firewall.interfaces.tailscale0 = {
      allowedTCPPorts = [ 22 ];
      allowedUDPPortRanges = [{from=60000; to=61000;}];
    };
}
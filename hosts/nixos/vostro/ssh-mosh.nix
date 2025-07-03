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
    # trust tailscale0 to allow ssh etc over that interface only
    networking.firewall.trustedInterfaces = ["tailscale0"];
}
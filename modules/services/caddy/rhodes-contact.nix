{ ... }:

{
  virtualHosts = {
    "*.rhodes.contact" = {
      extraConfig = ''
        tls /etc/caddy/certs/rhodes.contact_certificate.pem /etc/caddy/certs/rhodes.contact_key.pem
        @pairdrop host drop.rhodes.contact
        handle @pairdrop {
          reverse_proxy 127.0.0.1:3000
        }
      '';
    };
  };
}

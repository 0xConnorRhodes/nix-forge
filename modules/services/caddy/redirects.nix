{ ... }:

{
  virtualHosts = {
    "print.connorrhodes.com" = {
      extraConfig = ''
        redir https://tools.connorrhodes.com/home/print/{uri}
      '';
    };

    "share.rhodes.contact" = {
      extraConfig = ''
        tls /etc/caddy/certs/rhodes.contact_certificate.pem /etc/caddy/certs/rhodes.contact_key.pem
        redir https://files.connorrhodes.com/share/public_upload/
      '';
    };
  };
}

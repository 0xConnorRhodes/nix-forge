{ autheliaSSODotEngineer, robotsTxt, ... }:

{
  virtualHosts = {
    "auth.connor.engineer" = {
      extraConfig = ''
        tls /etc/caddy/certs/auth.connor.engineer_certificate.pem /etc/caddy/certs/auth.connor.engineer_key.pem
        reverse_proxy 127.0.0.1:9092
      '';
    };

    "bootstrap.connor.engineer" = {
      extraConfig = ''
        ${robotsTxt}
        root * /var/www/bootstrap
        file_server
      '';
    };

    "demo-notes.connor.engineer" = {
      extraConfig = ''
        ${autheliaSSODotEngineer}
        ${robotsTxt}
        root * /var/www/demo_notes
        file_server
      '';
    };
  };
}

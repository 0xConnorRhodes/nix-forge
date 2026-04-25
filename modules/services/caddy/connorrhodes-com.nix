{ secrets, autheliaSSO, robotsTxt, ... }:

{
  virtualHosts = {
    "auth.connorrhodes.com" = {
      extraConfig = ''
        tls /etc/caddy/certs/auth.connorrhodes.com_certificate.pem /etc/caddy/certs/auth.connorrhodes.com_key.pem
        reverse_proxy 127.0.0.1:9091
      '';
    };

    "home.connorrhodes.com" = {
      extraConfig = ''
        tls /etc/caddy/certs/home.connorrhodes.com_certificate.pem /etc/caddy/certs/home.connorrhodes.com_key.pem
        ${autheliaSSO}
        ${robotsTxt}
        reverse_proxy 127.0.0.1:4000
      '';
    };

    "pass.connorrhodes.com" = {
      extraConfig = ''
        tls /etc/caddy/certs/pass.connorrhodes.com_certificate.pem /etc/caddy/certs/pass.connorrhodes.com_key.pem
        ${robotsTxt}
        reverse_proxy 127.0.0.1:33461
      '';
    };

    "winter.connorrhodes.com" = {
      extraConfig = ''
        ${autheliaSSO}
        ${robotsTxt}
        reverse_proxy 10.93.82.129:58670 {
          header_up Remote-User {header.Remote-User}
          header_up Remote-Groups {header.Remote-Groups}
          header_up Remote-Name {header.Remote-Name}
          header_up Remote-Email {header.Remote-Email}
        }
      '';
    };

    "winter-dash.connorrhodes.com" = {
      extraConfig = ''
        ${autheliaSSO}
        ${robotsTxt}
        reverse_proxy 10.93.82.129:7000
      '';
    };

    "md.connorrhodes.com" = {
      extraConfig = ''
        ${autheliaSSO}
        ${robotsTxt}
        reverse_proxy 127.0.0.1:38157
      '';
    };

    "study-notes.connorrhodes.com" = {
      extraConfig = ''
        ${autheliaSSO}
        ${robotsTxt}
        reverse_proxy 127.0.0.1:38158
      '';
    };

    "api.connorrhodes.com" = {
      extraConfig = ''
        tls /etc/caddy/certs/api.connorrhodes.com_certificate.pem /etc/caddy/certs/api.connorrhodes.com_key.pem
        ${robotsTxt}
        reverse_proxy 127.0.0.1:62521
      '';
    };

    "s2.connorrhodes.com" = {
      extraConfig = ''
        ${autheliaSSO}
        ${robotsTxt}
        root * /zstore/static_files/s2_files
        file_server
      '';
    };

    "tools.connorrhodes.com" = {
      extraConfig = ''
        ${autheliaSSO}
        ${robotsTxt}
        reverse_proxy 127.0.0.1:4419
      '';
    };

    "files.connorrhodes.com" = {
      extraConfig = ''
        ${robotsTxt}
        reverse_proxy 127.0.0.1:26835 {
          header_up -Origin
        }
      '';
    };

    "news.connorrhodes.com" = {
      extraConfig = ''
        tls /etc/caddy/certs/news.connorrhodes.com_certificate.pem /etc/caddy/certs/news.connorrhodes.com_key.pem
        ${robotsTxt}
        reverse_proxy 127.0.0.1:39670
      '';
    };

    "tasks.connorrhodes.com" = {
      extraConfig = ''
        tls /etc/caddy/certs/tasks.connorrhodes.com_certificate.pem /etc/caddy/certs/tasks.connorrhodes.com_key.pem
        ${robotsTxt}
        @options method OPTIONS
        header @options Access-Control-Allow-Origin "https://tools.connorrhodes.com"
        header @options Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS"
        header @options Access-Control-Allow-Headers "Authorization, Content-Type, X-API-Key"
        header @options Access-Control-Max-Age "3600"
        respond @options 204
        header Access-Control-Allow-Origin "https://tools.connorrhodes.com"
        header Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS"
        header Access-Control-Allow-Headers "Authorization, Content-Type, X-API-Key"
        reverse_proxy 127.0.0.1:15177
      '';
    };

    "shelf.connorrhodes.com" = {
      extraConfig = ''
        ${robotsTxt}
        reverse_proxy 127.0.0.1:61793
      '';
    };

    "rl.connorrhodes.com" = {
      extraConfig = ''
        tls /etc/caddy/certs/rl.connorrhodes.com_certificate.pem /etc/caddy/certs/rl.connorrhodes.com_key.pem
        ${robotsTxt}
        reverse_proxy 127.0.0.1:38399
      '';
    };

    "bk.connorrhodes.com" = {
      extraConfig = ''
        tls /etc/caddy/certs/bk.connorrhodes.com_certificate.pem /etc/caddy/certs/bk.connorrhodes.com_key.pem
        ${robotsTxt}
        reverse_proxy 127.0.0.1:44514
      '';
    };

    "cc.connorrhodes.com" = {
      extraConfig = ''
        ${robotsTxt}
        handle_path /${secrets.radicale.public_path}/* {
          reverse_proxy 127.0.0.1:5232 {
            header_up Authorization "Basic ${secrets.radicale.basic_auth}"
          }
        }
        handle {
          reverse_proxy 127.0.0.1:5232
        }
      '';
    };

    "search.connorrhodes.com" = {
      extraConfig = ''
        tls /etc/caddy/certs/search.connorrhodes.com_certificate.pem /etc/caddy/certs/search.connorrhodes.com_key.pem
        ${robotsTxt}
        root * /var/www/search
        file_server
        @static {
          path *.js *.css *.svg
        }
        header @static Cache-Control "public, max-age=604800"
        @js {
          path *.js
        }
        header @js Content-Type application/javascript
        @json {
          path *.json
        }
        header @json Content-Type application/json
      '';
    };

    "photos.connorrhodes.com" = {
      extraConfig = ''
        ${robotsTxt}
        reverse_proxy 127.0.0.1:4312
        request_body {
          max_size 50000MB
        }
      '';
    };

    "casts.connorrhodes.com" = {
      extraConfig = ''
        ${autheliaSSO}
        ${robotsTxt}
        reverse_proxy 127.0.0.1:5001
      '';
    };

    "db.connorrhodes.com" = {
      extraConfig = ''
        ${autheliaSSO}
        ${robotsTxt}
        reverse_proxy 127.0.0.1:8081
      '';
    };

    "git.connorrhodes.com" = {
      extraConfig = ''
        ${robotsTxt}
        reverse_proxy 127.0.0.1:3200
      '';
    };

    "jf.connorrhodes.com" = {
      extraConfig = ''
        ${robotsTxt}
        reverse_proxy 127.0.0.1:8096
      '';
    };

    "mus.connorrhodes.com" = {
      extraConfig = ''
        ${robotsTxt}
        reverse_proxy 127.0.0.1:15612
      '';
    };

    "pod.connorrhodes.com" = {
      extraConfig = ''
        ${robotsTxt}
        reverse_proxy 127.0.0.1:34678
      '';
    };

    "podsync.connorrhodes.com" = {
      extraConfig = ''
        ${robotsTxt}
        reverse_proxy 127.0.0.1:29379
      '';
    };
  };
}

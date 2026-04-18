{ config, pkgs, pkgsUnstable, inputs, secrets, ... }:

let
  autheliaSSO = ''
    forward_auth 127.0.0.1:9091 {
      uri /api/verify?rd=https://auth.connorrhodes.com
      copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
    }
  '';

  autheliaSSODotEngineer = ''
    forward_auth 127.0.0.1:9092 {
      uri /api/verify?rd=https://auth.connor.engineer
      copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
    }
  '';

  robotsTxt = ''
    @robots path /robots.txt
    handle @robots {
      respond 200 {
        body "User-agent: *\nDisallow: /"
      }
    }
  '';
in
{
  services.caddy = {
    enable = true;
    package = pkgs.caddy;

    globalConfig = ''
      email ${secrets.caddy.email}
    '';

    virtualHosts = {
      "auth.connorrhodes.com" = {
        extraConfig = ''
          tls /etc/caddy/certs/auth.connorrhodes.com_certificate.pem /etc/caddy/certs/auth.connorrhodes.com_key.pem
          reverse_proxy 127.0.0.1:9091
        '';
      };

      "print.connorrhodes.com" = {
        extraConfig = ''
          tls /etc/caddy/certs/print.connorrhodes.com_certificate.pem /etc/caddy/certs/print.connorrhodes.com_key.pem
          ${autheliaSSO}
          ${robotsTxt}
          reverse_proxy 127.0.0.1:57928
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

      "term.connorrhodes.com" = {
        extraConfig = ''
          ${robotsTxt}
          @pwa_files path /service-worker.js /manifest.json /config.js /assets/*
          handle @pwa_files {
            header Service-Worker-Allowed "/"
            header Cache-Control "public, max-age=3600, must-revalidate"
            reverse_proxy 127.0.0.1:3002
          }
          @notPwaFiles not {
            path /service-worker.js /manifest.json /config.js /assets/*
          }
          handle @notPwaFiles {
            ${autheliaSSO}
            reverse_proxy 127.0.0.1:3002
          }
        '';
      };

      # "ssh.connorrhodes.com" = {
      #   extraConfig = ''
      #     forward_auth 127.0.0.1:9091 {
      #       uri /api/verify?rd=https://auth.connorrhodes.com
      #       copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
      #     }
      #     @robots path /robots.txt
      #     handle @robots {
      #       respond 200 {
      #         body "User-agent: *\nDisallow: /"
      #       }
      #     }
      #     reverse_proxy 127.0.0.1:36135
      #   '';
      # };

      "api.connorrhodes.com" = {
        extraConfig = ''
          tls /etc/caddy/certs/api.connorrhodes.com_certificate.pem /etc/caddy/certs/api.connorrhodes.com_key.pem
          ${robotsTxt}
          reverse_proxy 127.0.0.1:62521
        '';
      };

      # "budget.connorrhodes.com" = {
      #   extraConfig = ''
      #     tls /etc/caddy/certs/budget.connorrhodes.com_certificate.pem /etc/caddy/certs/budget.connorrhodes.com_key.pem
      #     @robots path /robots.txt
      #     handle @robots {
      #       respond 200 {
      #         body "User-agent: *\nDisallow: /"
      #       }
      #     }
      #     reverse_proxy 192.168.86.10:8954
      #   '';
      # };

      # "sfs.connorrhodes.com" = {
      #   extraConfig = ''
      #     tls /etc/caddy/certs/sfs.connorrhodes.com_certificate.pem /etc/caddy/certs/sfs.connorrhodes.com_key.pem
      #     @robots path /robots.txt
      #     handle @robots {
      #       respond 200 {
      #         body "User-agent: *\nDisallow: /"
      #       }
      #     }
      #     root * /mnt/sfs
      #     file_server
      #   '';
      # };

      # Files must be readable by the caddy user (member of the users group).
      # Run: chmod 640 /zstore/static_files/s2_files/*
      "s2.connorrhodes.com" = {
        extraConfig = ''
          ${autheliaSSO}
          ${robotsTxt}
          root * /zstore/static_files/s2_files
          file_server
        '';
      };

      # Content stored in /var/www/web_tools with symlink at ~/code/web_tools. Permissions: 0750 connor:users (caddy in users group)
      "tools.connorrhodes.com" = {
        extraConfig = ''
          ${autheliaSSO}
          ${robotsTxt}
          root * /var/www/web_tools
          file_server
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

      # "picard.connorrhodes.com" = {
      #   extraConfig = ''
      #     ${autheliaSSO}
      #     ${robotsTxt}
      #     reverse_proxy 127.0.0.1:5800
      #   '';
      # };

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

      # "calibre.connorrhodes.com" = {
      #   extraConfig = ''
      #     ${autheliaSSO}
      #     ${robotsTxt}
      #     reverse_proxy 127.0.0.1:29039 {
      #       transport http {
      #         tls_insecure_skip_verify
      #       }
      #     }
      #   '';
      # };

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

      # "sync.connorrhodes.com" = {
      #   extraConfig = ''
      #     tls /etc/caddy/certs/sync.connorrhodes.com_certificate.pem /etc/caddy/certs/sync.connorrhodes.com_key.pem
      #     ${autheliaSSO}
      #     ${robotsTxt}
      #     reverse_proxy 127.0.0.1:42631
      #   '';
      # };

      "*.rhodes.contact" = {
        extraConfig = ''
          tls /etc/caddy/certs/rhodes.contact_certificate.pem /etc/caddy/certs/rhodes.contact_key.pem
          @share host share.rhodes.contact
          handle @share {
            redir https://files.connorrhodes.com/share/public_upload/
          }
          @pairdrop host drop.rhodes.contact
          handle @pairdrop {
            reverse_proxy 127.0.0.1:3000
          }
        '';
      };

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

      # Content stored in /var/www/demo_notes, built by just command in ~/code/demo-notes-connor-engineer
      "demo-notes.connor.engineer" = {
        extraConfig = ''
          ${autheliaSSODotEngineer}
          ${robotsTxt}
          root * /var/www/demo_notes
          file_server
        '';
      };
    };
  };

  # Bind mount folders to /var/www for caddy access
  fileSystems."/var/www/bootstrap" = {
    device = "/home/connor/code/scripts/bootstrap";
    options = [ "bind" "X-nosuid" "X-nodev" "X-noexec" ];
  };
  fileSystems."/var/www/demo_notes" = {
    device = "/home/connor/code/demo-notes-connor-engineer/build";
    options = [ "bind" "X-nosuid" "X-nodev" "X-noexec" ];
  };
  fileSystems."/var/www/web_tools" = {
    device = "/home/connor/code/web_tools";
    options = [ "bind" "X-nosuid" "X-nodev" "X-noexec" ];
  };
  fileSystems."/var/www/search" = {
    device = "/home/connor/code/my-unduck/dist";
    options = [ "bind" "X-nosuid" "X-nodev" "X-noexec" ];
  };

  users.groups.users.members = [ "caddy" ];
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}

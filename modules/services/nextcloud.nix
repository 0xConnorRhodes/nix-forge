{ config, lib, pkgs, ... }:

{
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud32;
    hostName = "nc.connorrhodes.com";
    https = true;

    # Use SQLite database
    config = {
      dbtype = "sqlite";
      adminuser = null;
      adminpassFile = null;
    };

    settings = {
      overwrite.cli.url = "https://nc.connorrhodes.com";
      overwriteprotocol = "https";
      default_phone_region = "US";
      trusted_proxies = [ "127.0.0.1" "::1" ];
    };

    phpOptions = {
      "opcache.interned_strings_buffer" = "16";
    };

    # Disable automatic app store since we're doing local setup
    appstoreEnable = false;
  };

  # Configure nginx to listen on localhost only (for Caddy reverse proxy)
  services.nginx.virtualHosts."nc.connorrhodes.com" = lib.mkForce {
    listen = [
      { addr = "127.0.0.1"; port = 51352; }
    ];
    root = config.services.nextcloud.finalPackage;
    forceSSL = lib.mkForce false;
    enableACME = lib.mkForce false;

    locations = {
      "= /robots.txt" = {
        priority = 100;
        extraConfig = ''
          allow all;
          access_log off;
        '';
      };

      "= /" = {
        priority = 100;
        extraConfig = ''
          if ( $http_user_agent ~ ^DavClnt ) {
            return 302 /remote.php/webdav/$is_args$args;
          }
        '';
      };

      "^~ /.well-known" = {
        priority = 210;
        extraConfig = ''
          absolute_redirect off;
          location = /.well-known/carddav {
            return 301 /remote.php/dav/;
          }
          location = /.well-known/caldav {
            return 301 /remote.php/dav/;
          }
          location ~ ^/\.well-known/(?!acme-challenge|pki-validation) {
            return 301 /index.php$request_uri;
          }
          try_files $uri $uri/ =404;
        '';
      };

      "~ ^/(?:build|tests|config|lib|3rdparty|templates|data)(?:$|/)" = {
        priority = 450;
        extraConfig = ''
          return 404;
        '';
      };

      "~ ^/(?:\\.|autotest|occ|issue|indie|db_|console)" = {
        priority = 450;
        extraConfig = ''
          return 404;
        '';
      };

      "~ \\.php(?:$|/)" = {
        priority = 500;
        extraConfig = ''
          # legacy support (i.e. static files and directories in cfg.package)
          rewrite ^/(?!index|remote|public|cron|core\/ajax\/update|status|ocs\/v[12]|updater\/.+|ocs-provider\/.+|.+\/richdocumentscode(_arm64)?\/proxy) /index.php$request_uri;
          include ${config.services.nginx.package}/conf/fastcgi.conf;
          fastcgi_split_path_info ^(.+?\.php)(\/.*)$;
          set $path_info $fastcgi_path_info;
          try_files $fastcgi_script_name =404;
          fastcgi_param PATH_INFO $path_info;
          fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
          fastcgi_param HTTPS on;
          fastcgi_param modHeadersAvailable true;
          fastcgi_param front_controller_active true;
          fastcgi_pass unix:${config.services.phpfpm.pools.nextcloud.socket};
          fastcgi_intercept_errors on;
          fastcgi_request_buffering off;
          fastcgi_read_timeout 120s;
        '';
      };

      "~ \\.(?:css|js|mjs|svg|gif|ico|jpg|jpeg|png|webp|wasm|tflite|map|html|ttf|bcmap|mp4|webm|ogg|flac)$" = {
        priority = 500;
        extraConfig = ''
          try_files $uri /index.php$request_uri;
          expires 6M;
          access_log off;
          location ~ \.mjs$ {
            default_type text/javascript;
          }
          location ~ \.wasm$ {
            default_type application/wasm;
          }
        '';
      };

      "~ ^\\/(?:updater|ocs-provider)(?:$|\\/)" = {
        priority = 600;
        extraConfig = ''
          try_files $uri/ =404;
          index index.php;
        '';
      };

      "/remote" = {
        priority = 1500;
        extraConfig = ''
          return 301 /remote.php$request_uri;
        '';
      };

      "/" = {
        priority = 1600;
        extraConfig = ''
          try_files $uri $uri/ /index.php$request_uri;
        '';
      };
    };

    extraConfig = ''
      index index.php index.html /index.php$request_uri;
      add_header X-Content-Type-Options nosniff;
      add_header X-Robots-Tag "noindex, nofollow";
      add_header X-Permitted-Cross-Domain-Policies none;
      add_header X-Frame-Options sameorigin;
      add_header Referrer-Policy no-referrer;
      client_max_body_size 512M;
      fastcgi_buffers 64 4K;
      fastcgi_hide_header X-Powered-By;
      # mirror upstream htaccess file
      fastcgi_hide_header Referrer-Policy;
      fastcgi_hide_header X-Content-Type-Options;
      fastcgi_hide_header X-Frame-Options;
      fastcgi_hide_header X-Permitted-Cross-Domain-Policies;
      fastcgi_hide_header X-Robots-Tag;
      gzip on;
      gzip_vary on;
      gzip_comp_level 4;
      gzip_min_length 256;
      gzip_proxied expired no-cache no-store private no_last_modified no_etag auth;
      gzip_types application/atom+xml text/javascript application/javascript application/json application/ld+json application/manifest+json application/rss+xml application/vnd.geo+json application/vnd.ms-fontobject application/wasm application/x-font-ttf application/x-web-app-manifest+json application/xhtml+xml application/xml font/opentype image/bmp image/svg+xml image/x-icon text/cache-manifest text/css text/plain text/vcard text/vnd.rim.location.xloc text/vtt text/x-component text/x-cross-domain-policy;
    '';
  };
}

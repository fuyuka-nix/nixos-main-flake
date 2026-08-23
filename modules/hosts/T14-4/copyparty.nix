{
  den,
  ...
}:
{
  den.aspects.T14-4.nixos = { config, lib, ... }:
  let
    vhost = config.vhosts.copyparty;
  in
  {
    vhosts.copyparty = {
      localAddr = "127.0.0.1";
      localPort = 3992;
      autoSetNginx = false;
    };

    services.nginx = {
      virtualHosts."[${vhost.ygg}]" = {
        listen = [
          {
            addr = "[${vhost.ygg}]";
            port = 80;
          }
        ];
        locations."/" = {
          proxyPass = "http://${vhost.localAddr}:${lib.toString vhost.localPort}";
          extraConfig = ''
            proxy_redirect off;

            proxy_http_version 1.1;
            proxy_buffering off;
            proxy_request_buffering off;

            proxy_buffers 32 8k;
            proxy_buffer_size 16k;
            proxy_busy_buffers_size 24k;

            proxy_set_header   Connection        "Keep-Alive";
            proxy_set_header   Host              $host;
            proxy_set_header   X-Real-IP         $remote_addr;
            proxy_set_header   X-Forwarded-Proto $scheme;
            proxy_set_header   X-Forwarded-For   $proxy_add_x_forwarded_for;

            proxy_set_header   Authorization     $http_authorization;

            proxy_set_header Depth $http_depth;
            proxy_set_header Destination $http_destination;
            proxy_set_header Overwrite $http_overwrite;
            proxy_set_header If $http_if;

            client_max_body_size 0;
          '';
        };
      };
    };

    sops.secrets."copyparty/fox" = {
      owner = config.services.copyparty.user;
      group = config.services.copyparty.group;
      mode = "0440";
    };

    services.copyparty = {
      enable = true;
      user = "foxnix";
      group = "users";

      settings = {
        i = vhost.localAddr;
        p = vhost.localPort;
        usernames = true;
        dav-auth = true;
        xff-hdr = "X-Forwarded-For";
        xff-src = "any";
        rproxy = 1;
        ihead = "*";
      };

      accounts = {
        fox.passwordFile = "/run/secrets/copyparty/fox";
      };

      volumes = {
        "/fox" = {
          path = "/home/foxnix/copyparty";
          access = {
            A = "fox";
          };
          flags = {
            fk = 4;
            scan = 120;
            nohast = "\\.iso$";
          };
        };
      };
    };
  };
}

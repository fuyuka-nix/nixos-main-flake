{
  den,
  ...
}:
{
  den.aspects.T14-4.nixos = { config, lib, pkgs, ... }:
  let
    yggNextcloud = config.vhosts.nextcloud;
  in
  {
    vhosts.nextcloud = {
      localPort = 80;
      localAddr = "192.168.2.2";
    };

    services.nginx.virtualHosts."${config.vhosts.nextcloud.ygg}" = {
      locations."/".extraConfig = ''
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-NginX-Proxy true;
        proxy_set_header X-Forwarded-Proto http;
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_redirect off;
      '';
        #proxy_pass http://127.0.0.1:8080/;
    };

    environment.systemPackages = [ pkgs.nextcloud-client ];
    #networking.firewall.allowedTCPPorts = [ 80 ];

    networking.nat = {
      enable = true;
      internalInterfaces = [ "br0" ];
      externalInterface = "wlp0s20f3";
      enableIPv6 = true;
    };

    systemd.network = {
      enable = true;
      wait-online.enable = false;
      netdevs = {
          "20-br0" = {
            netdevConfig = {
              Kind = "bridge";
              Name = "br0";
            };
          };
      };
      networks = {
        "40-br0" = {
          matchConfig.Name = "br0";
          address = [
            "192.168.2.1/29"
          ];
          # bridgeConfig = {};
          # Disable address autoconfig when no IP configuration is required
          # networkConfig.LinkLocalAddressing = "no";
          # linkConfig = {
            # or "routable" with IP addresses configured
            # RequiredForOnline = "carrier";
          # };
        };
      };
    };

    containers.nextcloud = {
      autoStart = true;
      privateNetwork = true;
      hostBridge = "br0";

      #hostAddress = "192.168.2.1";
      localAddress = "192.168.2.2/29";
      config = { config, lib, pkgs, ...}: {
        system.stateVersion = "26.05";

        networking = {
          firewall.allowedTCPPorts = [ 80 ];
          nameservers = [ "1.1.1.1" "9.9.9.9" ];
          # Use systemd-resolved inside the container
          # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
          useHostResolvConf = lib.mkForce false;
          defaultGateway = { address = "192.168.2.1"; };
        };

        services.resolved.enable = true;

        services.nextcloud = {
          enable = true;
          package = pkgs.nextcloud34;
          hostName = "300:a09d:7102:3805:a2a1:e69c:4f83:40f6";
          configureRedis = true;
          caching.redis = true;

          extraAppsEnable = true;
          appstoreEnable = true;
          extraApps = {
            inherit (config.services.nextcloud.package.packages.apps) contacts calendar tasks;
          };

          config = {
            adminuser = "foxnix";
            adminpassFile = "/etc/secrets/nextcloud/admin";
            dbtype = "sqlite";
          };
          settings = {
            trusted_domains = [
              "[${config.services.nextcloud.hostName}]"
              "192.168.2.2"
            ];
          };
        };

        services.fail2ban = {
          enable = true;
          jails = {
            # The jail file defines how to handle the failed authentication attempts found by the Nextcloud filter
            # Ref: https://docs.nextcloud.com/server/latest/admin_manual/installation/harden_server.html#setup-a-filter-and-a-jail-for-nextcloud
            nextcloud.settings = {
              # modification to work with syslog instead of logile
              backend = "systemd";
              journalmatch = "SYSLOG_IDENTIFIER=Nextcloud";

              enabled = true;
              port = 80;
              protocol = "tcp";
              filter = "nextcloud";
              maxretry = 3;
              bantime = 86400;
              findtime = 43200;
            };
          };
        };

        environment.etc = {
          # Adapted failregex for syslogs
          "fail2ban/filter.d/nextcloud.local".text = pkgs.lib.mkDefault (pkgs.lib.mkAfter ''
            [Definition]
            failregex = ^.*"remoteAddr":"&lt;HOST&gt;".*"message":"Login failed:
                        ^.*"remoteAddr":"&lt;HOST&gt;".*"message":"Two-factor challenge failed:
                        ^.*"remoteAddr":"&lt;HOST&gt;".*"message":"Trusted domain error.
          '');
        };
      };
    };

  };
}

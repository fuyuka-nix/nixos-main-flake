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
      localAddr = "[${config.containers.nextcloud.localAddress6}]";
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

    containers.nextcloud = {
      autoStart = true;
      privateNetwork = true;
      hostAddress6 = "fc00::1";
      localAddress6 = "fc00::2";
      config = { config, lib, pkgs, ...}: {
        system.stateVersion = "26.05";

        networking = {
          firewall = {
            enable = true;
            allowedTCPPorts = [ 80 ];
          };
          # Use systemd-resolved inside the container
          # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
          useHostResolvConf = lib.mkForce false;
        };

        services.nextcloud = {
          enable = true;
          package = pkgs.nextcloud34;
          hostName = "302:bf3d:9ff8:9cc:a2a1:e69c:4f83:40f6";
          configureRedis = true;
          caching.redis = true;

          extraAppsEnable = true;
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
              "[302:bf3d:9ff8:9cc:a2a1:e69c:4f83:40f6]"
              "[fc00::2]"
              "[fc00::1]"
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

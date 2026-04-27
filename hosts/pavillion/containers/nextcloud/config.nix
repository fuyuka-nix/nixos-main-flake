{
  pkgs,
  ...
}:
let
  containerRoot = "/var/lib/nixos-containers/nextcloud";
in
{
  services = {
    mysql = {
      enable = true;
      package = pkgs.mariadb;
    };

    redis.servers.nextcloud = {
      enable = true;
      port = 6379;
    };

    nginx = {
      enable = true;
      virtualHosts."localhost" = {
	listen = [{ addr = "127.0.0.1"; port = 80; }];

	locations."/" = {
          tryFiles = "$uri $uri/ /index.php$is_args$args";
          index = "index.php";
            
          extraConfig = ''
            location ~ \.php$ {
              fastcgi_pass unix:/run/php-fpm/nextcloud.sock;
              fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
              include fastcgi_params;
            }
          '';
        };
      };
    };

    phpfpm = {
      phpPackage = pkgs.php;
      pools.nextcloud = {
	user = "nextcloud";
	group = "nextcloud";
	settings = {
	  "memory_limit" = "512M";
	};
      };
    };

    nextcloud = {
      enable = true;
      package = pkgs.nextcloud33;
      https = false; # internal Tor HTTP only
      hostName = "localhost";
      config = {
	dbtype = "mysql";
	dbname = "nextcloud";
	dbuser = "nextcloud";
	adminpassFile = "/etc/winter-secrets/nxtcloud.txt";
      };
      settings = {
	# change
        trusted_domains = [ "nxtcloud.fuyukayd6cbyycqfcaupxrgurr6zngv2lgqagqbuyocxrhv3ojk47pid.onion" ];
        overwriteprotocol = "http";
        proxy = "127.0.0.1:9050"; 
      };
    };

    tor = {
      enable = true;
      client.enable = true;

      settings = {
	SOCKSPort = [{ port = 9050; }];
      };
      
      relay.onionServices = {
        nextcloud = {
          path = "${containerRoot}/hidden_service/nextcloud";
	  map = [
	    {
	      port = 80;
	      target = {
		addr = "127.0.0.1";
		port = 4443;
	      };
	    }
	  ];
        };
      };

      torsocks = {
	enable = true;
      };
    };
  };
}

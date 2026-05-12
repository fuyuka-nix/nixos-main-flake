{
  pkgs,
  ...
}:
let
  onion = "fuyukayd6cbyycqfcaupxrgurr6zngv2lgqagqbuyocxrhv3ojk47pid.onion";
in
{
  system.stateVersion = "25.11";
  environment.systemPackages = with pkgs; [
    yazi
    man
  ];
  programs.vim.enable = true;

  users.users.fox = {
    isNormalUser = true;
    initialPassword = "shi";
    extraGroups = [
      "input"
      "wheel"
    ];
  };

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
	adminpassFile = "/etc/nextcloud.txt";
      };
      settings = {
        trusted_domains = [ "nxtcloud.${onion}" ];
        overwriteprotocol = "http";
        proxy = "127.0.0.1:9050"; 
      };
    };

    tor = {
      enable = true;
      openFirewall = true;

      settings = {
	SOCKSPort = [{ port = 9050; }];
	ORPort = "auto";
      };

      relay = {
	enable = true;
	role = "relay";
	onionServices = {
	  "${onion}" = {
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
      };
    };
  };
}

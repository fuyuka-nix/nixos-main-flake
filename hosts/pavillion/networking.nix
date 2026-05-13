{
  ...
}:
let
  onion = "fuyukayd6cbyycqfcaupxrgurr6zngv2lgqagqbuyocxrhv3ojk47pid.onion";
in
{
  services = {
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
		target = { addr = "127.0.0.1"; port = 4443; };
	      }
	    ];
	  };
        };
      };
    };

    nginx = {
      enable = true;
      upstreams = {
	nxtcloudbackend = {
	  servers = {
	    "10.7.0.1:8081" = { };
	  };
	};
      };
      virtualHosts = {
	"nxtcloud.${onion}" = {
	  listen = [
	    {
	      addr = "127.0.0.1";
	      port = 4443;
	    }
	    {
	      addr = "[::]";
	      port = 4443;
	    }
	  ];
	  locations."/" = {
	    proxyPass = "http://nxtcloudbackend";
	  };
	};
      };
    };
  };
}

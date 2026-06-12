{
  den,
  ...
}:
let
  toIpv6Address = prefix64: seed: seed
    |> builtins.hashString "sha256"
    |> (x: map (i: builtins.substring (4 * i) 4 x) [ 0 1 2 3 ])
    |> (x: builtins.concatStringsSep ":" ([ prefix64 ] ++ x));
  yggPrefix = "300:3467:ae65:977a";
  yggAddr = "200:3467:ae65:977a:be15:dd9a:53c4:6964";
  toIpv6Address' = toIpv6Address yggPrefix;
in
{
  den.aspects.pavillion.nixos = { config, lib, ... }: {
    options = {
      vhosts = lib.mkOption {
	description = "Attrset of HTTP virtual-hosts to create Yggdrasil addresses for.";
	type = with lib.types;
	  attrsOf <| submodule ({ name, ... }: {
	    options = {
	      ygg = lib.mkOption {
		description = "Yggdrasil address to create for this virtual-host";
		type = str;
		default = toIpv6Address' name;
	      };
	    };
	  });
      };
    };
    config = {
      vhosts = {
	radicale = { };
      };

      networking = {
	networkmanager.enable = true;
	hostName = "pavillion";
	firewall = {
	  enable = true;
	  trustedInterfaces = [ "${config.services.yggdrasil.settings.IfName}" ];
	  allowedTCPPorts = [ 80 443 22 ];
	};

	interfaces.${config.services.yggdrasil.settings.IfName}.ipv6.addresses = [{
	  address = yggAddr;
	  prefixLength = 128;
	}]
	++ (config.vhosts |> lib.mapAttrsToList (_: { ygg, ... }: {
	  address = ygg;
	  prefixLength = 64;
	}));
      };

      services = {
	fail2ban.enable = true;
	nginx = {
	  enable = true;
	  virtualHosts = with config.vhosts; {
	    "${radicale.ygg}" = {
	      listen = [{ addr = "[::]"; port = 80; }];
	      locations."/" = {
		proxyPass = "http://127.0.0.1:5053";
		extraConfig = ''
		  proxy_pass_header Authorization;
		'';
	      };
	    };
	  };
	};
	tor = {
	  enable = true;
	  openFirewall = true;
	  torsocks.enable = true;

	  client = {
	    enable = true;
	  };
	};
	yggdrasil = {
	  enable = true;
	  group = "wheel";
	  openMulticastPort = true;
	  settings = {
	    IfName = "ygg0";
	    PrivateKeyPath = "/run/secrets/ygg/private";
	    Peers = [
	      "tcp://satori.nadeko.net:44441"
	      "tcp://ygg.nadeko.net:44441"
	      "tcp://ygg-1.okade.pro:20000"
	    ];
	  };
	};
	radicale = {
	  enable = true;
	  settings = {
	    server.hosts = [ "0.0.0.0:5053" ];
	    auth = {
	      type = "htpasswd";
	      htpasswd_filename = "/run/secrets/radicale-pass";
	      htpasswd_encryption = "plain";
	    };
	  };
	};
      };
    };
  };
}

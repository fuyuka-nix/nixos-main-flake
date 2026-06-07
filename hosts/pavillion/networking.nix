{
  config,
  lib,
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
      test = { ygg = "${yggPrefix}::1"; };
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
	/*
	  "${test.ygg}" = {
	    listen = [{ addr = "[::]"; port = 80; }];
	    locations."/" = {
	      return = "200 '<html><body>It just works</body></html>'";
	      extraConfig = ''
		default_type text/html;
	      '';
	    };
	  };
	  */
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
    };
  };
}

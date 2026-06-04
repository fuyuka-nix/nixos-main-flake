{
  lib,
  ...
}:
let
  # Destroy unneded variables, embrace pipes
  toIpv6Address = prefix64: seed: seed
    |> builtins.hashString "sha256"
    |> (x: map (i: builtins.substring (4 * i) 4 x) [ 0 1 2 3 ])
    |> (x: builtins.concatStringsSep ":" ([ prefix64 ] ++ x));
  yggPrefix = "300:3467:ae65:977a";
in
{
  networking = {
    networkmanager.enable = true;
    hostName = "pavillion";
    firewall.enable = true;
  };
  services = {
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
	AllowedPublicKeys = [
	  "466a6c8313ae63052639a09bc053f1be9901357633add9ad8de636dfeb604a6f"
	];
      };
    };
  };
}

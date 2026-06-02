{
  ...
}:
let
  yggPrefix = "300:9eba:ceda:4c59";
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
      persistentKeys = true;
      openMulticastPort = true;
      settings = {
	IfName = "ygg0";
	Listen = [ "[::]:0" ];
	Peers = [
	  "tcp://satori.nadeko.net:44441"
	  "tcp://ygg.nadeko.net:44441"
	  "tcp://ygg-1.okade.pro:20000"
	];
	MulticastInterfaces = [ "eno1" "wlo1" ];
	AllowedPublicKeys = [
	  "466a6c8313ae63052639a09bc053f1be9901357633add9ad8de636dfeb604a6f"
	];
      };
    };
  };
}

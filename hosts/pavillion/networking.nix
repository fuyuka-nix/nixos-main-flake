{
  ...
}:
{
  networking = {
    networkmanager.enable = true;
    hostName = "Pavillion-Laptop";
    firewall.enable = true;
  };
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
      };
    };
    yggdrasil = {
      enable = true;
      configFile = "/etc/yggdrasil.conf";
      group = "wheel";
      settings = {
	Peers = [
	  "tcp://satori.nadeko.net:44441"
	  "tcp://ygg-1.okade.pro:20000"
	];
      };
    };
  };
}

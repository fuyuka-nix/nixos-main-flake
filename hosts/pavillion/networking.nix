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
      torsocks.enable = true;

      settings = {
	SOCKSPort = [{ port = 9050; }];
      };

      client = {
	enable = true;
      };
    };
    yggdrasil = {
      enable = true;
      configFile = "/etc/yggdrasil.conf";
      group = "wheel";
    };
  };
}

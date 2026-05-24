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
  };
}

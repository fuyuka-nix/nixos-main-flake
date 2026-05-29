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

{
  pkgs,
  ...
}:
let
  onion = "fuyukayd6cbyycqfcaupxrgurr6zngv2lgqagqbuyocxrhv3ojk47pid.onion";
in
{
  system.stateVersion = "25.11";
  programs.vim.enable = true;

  networking.firewall = {
    allowedTCPPorts = [ 80 9050 ];
  };

  services = {
    mysql = {
      enable = true;
      package = pkgs.mariadb;
      ensureDatabases = [
	"nextcloud"
      ];
      ensureUsers = [
	{
	  name = "nextcloud";
	  ensurePermissions = {
	    "nextcloud.*" = "ALL PRIVILEGES";
	  };
	}
      ];
    };
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud33;
      https = false;
      hostName = "localhost";
      config = {
	dbtype = "mysql";
	adminpassFile = "/etc/nextcloud-pass";
      };
      settings = {
        trusted_domains = [ "nxtcloud.${onion}" ];
        overwriteprotocol = "http";
        proxy = "10.7.0.1:9050"; 
      };
    };
  };
}

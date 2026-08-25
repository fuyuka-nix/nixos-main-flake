{
  den,
  ...
}:
{
  den.aspects.T14-4.nixos = { config, lib, ... }:
  let
    vhost = config.vhosts.glance;
  in {
    vhosts.glance = {
      localPort = 5054;
    };

    services = { 
      nginx.virtualHosts."[${vhost.ygg}]" = {
        listen = [
          {
            addr = "[${vhost.ygg}]";
            port = 80;
          }
        ];
        locations."/" = {
          proxyPass = "http://${vhost.localAddr}:${lib.toString vhost.localPort}";
        };
      };
      glance = {
        enable = true;
        settings = {
          server.port = vhost.localPort;
        };
      };
    };
  };
}

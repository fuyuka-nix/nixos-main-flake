{
  den,
  ...
}:
{
  den.aspects.T14-4.nixos = { config, ... }: {
    services.glance = {
      enable = true;
      settings = {
        server.port = 5054;
      };
    };

    vhosts.glance = {
      localPort = config.services.glance.settings.server.port;
    };
  };
}

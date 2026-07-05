{
  den,
  ...
}:
{
  den.aspects.frozenfox.nixos = {
    services.glance = {
      enable = true;
      settings = {
	server.port = 5054;
      };
    };
  };
}

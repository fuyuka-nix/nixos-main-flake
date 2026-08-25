{
  den,
  ...
}:
{
  den.aspects.T14-4.nixos = { pkgs, ...}: {
    systemd.services.minecraft-server.enable = lib.mkForce false;
    services = {
      minecraft-server = {
        enable = true;
        eula = true;
        package = pkgs.papermcServers.papermc;
      };
    };
  };
}

{
  den,
  ...
}:
{
  den.aspects.T14-4.nixos = { lib, ... }: {
    systemd.services.syncthing = {
      after = lib.mkForce [];
      wantedBy = lib.mkForce [];
    };
    services.syncthing = {
      enable = true;
      user = "foxnix";
      group = "users";
      dataDir = "/home/foxnix/shared";
      overrideDevices = false;
      overrideFolders = false;
    };
  };
}

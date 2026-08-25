{
  den,
  ...
}:
{
  den.aspects.T14-4.nixos = {
    networking.nftables.enable = true;
    services.nginx.enable = true;
    networking.networkmanager.enable = true;

    ygg.address = "200:a09d:7102:3805:8e3d:4ed8:833c:d932";
    ygg.prefix = "300:a09d:7102:3805";
    services.yggdrasil = {
      settings = {
        Listen = [
          "tcp://[::]:8080"
          "ws://[::]:4442"
        ];
        PrivateKeyPath = "/run/secrets/ygg/private";
      };
    };

    services = {
      i2pd = {
        enable = true;
        /*
        proto = {
          http.enable = true;
          httpProxy.enable = true;
          socksProxy.enable = true;
          sam.enable = true;
          i2cp = {
            enable = true;
            address = "127.0.0.1";
            port = 7654;
          };
        };
        */
      };
    };
  };
}

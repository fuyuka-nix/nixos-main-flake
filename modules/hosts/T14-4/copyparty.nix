{
  den,
  ...
}:
{
  den.aspects.T14-4.nixos = { config, ... }: {
    vhosts.copyparty = {
      localPort = 3992;
    };

    sops.secrets."copyparty/fox" = {
      owner = config.services.copyparty.user;
      group = config.services.copyparty.group;
      mode = "0440";
    };

    services.copyparty = {
      enable = true;
      user = "foxnix";
      group = "foxnix";

      settings = {
        i = "::";
        p = config.vhosts.copyparty.localPort;
      };

      accounts = {
        fox.passwordFile = "/run/secrets/copyparty/fox";
      };

      volumes = {
        "/fox" = {
          path = "/home/foxnix/copyparty";
          access = {
            rw = "fox";
          };
          flags = {
            fk = 4;
            scan = 120;
            nohast = "\.iso$";
          };
        };
      };
    };
  };
}

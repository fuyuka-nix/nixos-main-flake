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
    };

    services.copyparty = {
      enable = true;
      user = "copyparty";
      group = "copyparty";

      settings = {
        i = "::";
        p = config.vhosts.copyparty.localPort;
      };

      accounts = {
        fox.passwordFile = "/run/secrets/copyparty/fox";
      };
    };
  };
}

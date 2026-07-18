{
  lib,
  den,
  ...
}:
let
  toIpv6Address = prefix64: seed: lib.pipe seed [
    (builtins.hashString "sha256")
    (x: map (i: builtins.substring (4 * i) 4 x) [ 0 1 2 3 ])
    (x: builtins.concatStringsSep ":" ([ prefix64 ] ++ x))
  ];
  vhost = { name, ... }: {
    options = {
      ygg = lib.mkOption {
        description = "Yggdrasil address to create for this virtual-host";
        type = lib.types.str;
        default = toIpv6Address' name;
      };
      localPort = lib.mkOption {
        description = "port to forward ygg trafic to with nginx";
        type = lib.types.port;
      };
      pubPort = lib.mkOption {
        description = "port to listen from nginx";
        type = lib.types.port;
        default = 80;
      };
    };
  };

  vhost' = lib.types.submodule vhost;
in
{
  den.aspects.yggdrasil.nixos = { config, lib, ... }: {
    options = {
      vhosts = lib.mkOption {
        description = "Attrset of HTTP virtual-hosts to create Yggdrasil addresses for.";
        type = lib.types.attrsOf vhost';
      };
      ygg = lib.mkOption {
        description = "custom yggdrasil options";
        type = lib.types.submodule ({
          options = {
            prefix = lib.mkOption {
              description = "yggdrasil prefix";
              type = lib.types.str;
            };
            address = {
              description = "yggdrasil address";
              type = lib.types.str;
            };
          };
        });
      };
    };
    config = let
      yggIfName = config.services.yggdrasil.settings.IfName;
      toIpv6Address' = toIpv6Address config.ygg.prefix;
    in {
      networking = {
        firewall = {
          trustedInterfaces = [ "${yggIfName}" ];
          #allowedTCPPorts = [ 80 443 22 ];
        };

        interfaces.${yggIfName}.ipv6.addresses = [{
          address = yggAddr;
          prefixLength = 128;
        }]
        ++
        lib.pipe config.vhosts [
          (lib.mapAttrsToList (_: { ygg, ... }:
            { address = ygg; prefixLength = 64; }
          ))
        ];
      };

      services = {
        nginx = {
          enable = true;
          virtualHosts = lib.mapAttrs'
            (name: value: nameValuePair "${value.ygg}" {
              listen = [{ addr = "${value.ygg}"; port = ${value.pubPort}; }];
              locations."/".proxyPass = "http://localhost:${value.localPort}"
            })
            config.vhosts;
        };
        yggdrasil = {
          enable = true;
          group = "wheel";
          openMulticastPort = lib.mkDefault true;
          settings = {
            IfName = lib.mkDefault "ygg0";
            PrivateKeyPath = lib.mkDefault "/run/secrets/ygg/private";
            Peers = [
              "tcp://satori.nadeko.net:44441"
              "tcp://ygg.nadeko.net:44441"
              "tcp://ygg-1.okade.pro:20000"
            ];
          };
        };
      };
    };
  };
}

{
  pkgs,
  ...
}:
{
  environment.systemPackages = [ pkgs.arrpc ];
  systemd.services."arrpc" = {
    description = "open source implementation of Discord's RPC";
    path = [ pkgs.arrpc ];
    script = "arrpc";
  };
}

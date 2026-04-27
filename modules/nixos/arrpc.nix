{
  pkgs,
  ...
}:
{
  systemd.user.services."arrpc" = {
    name = "arrpc";
    description = "open source implementation of Discord's RPC";
    path = [ pkgs.arrpc ];
    script = "arrpc";
  };
}

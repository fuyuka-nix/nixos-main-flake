{
  inputs,
  den,
  ...
}:
{
  imports = [ inputs.den.flakeModule ];

  den.hosts.x86_64-linux = {
    pavillion.users.frozenfox = { };
  };
}

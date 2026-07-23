{
  inputs,
  den,
  ...
}:
{
  imports = [ inputs.den.flakeModule ];

  den.hosts.x86_64-linux = {
    pavillion.users.frozenfox = {
      classes = [ "maid" ];
    };
    T14-4.users = {
      foxnix = {
        classes = [ "maid" ];
      };
      fennec = {
        classes = [ "maid" ];
      };
    };
  };
}

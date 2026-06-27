{
  den,
  ...
}:
{
  den.aspects.frozenfox.maid = { pkgs, ...}: {
    packages = [ pkgs.diff-so-fancy ];
    file.home.".config/git/config".source = ./gitconfig;
  };
}

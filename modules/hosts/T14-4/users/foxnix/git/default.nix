{
  den,
  ...
}:
{
  den.aspects.foxnix.maid = { pkgs, ... }: {
    packages = [ pkgs.diff-so-fancy ];
    file.home.".config/git/config".source = ./gitconfig;
  };
}

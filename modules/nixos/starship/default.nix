{
  lib,
  config,
  ...
}:
let
  cfg = config.modules.starship;
  moduleList = [
    "frosted-kebab"
  ];
in
{
  options.modules.starship = lib.genAttrs moduleList (x: {
    enable = lib.mkEnableOption "${x} preset";
  });

  imports = map (x: ./${x}.nix) moduleList;
}


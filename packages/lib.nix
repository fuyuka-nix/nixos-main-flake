{
  systems,
  nixpkgs
}:
let
  lib = nixpkgs.lib;
in
rec {
  # shorthand to build nixpkgs with allowUnfree
  withSystem = system: nixpkgs: (
    import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    }
  );

  # { _ = (_: ...); } where _ is a system
  eachSystem = lib.genAttrs systems;

  # { _ = (pkgs: ... ); } where _ is a system
  forAllSystems = nixpkgs-input: function:
    eachSystem (system: function (withSystem system nixpkgs-input));
}

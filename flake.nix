{
  outputs = inputs:
    (inputs.nixpkgs.lib.evalModules {
      modules = [ (inputs.import-tree ./modules) ];
      specialArgs.inputs = inputs;
    }).config.flake;

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    import-tree.url = "github:denful/import-tree";
    den.url = "github:denful/den";
    preservation.url = "github:nix-community/preservation";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    affinity-nix.url = "github:mrshmllow/affinity-nix";
    custompkgs.url = "github:rishabh5321/custom-packages-flake";
    freesm.url = "github:FreesmTeam/FreesmLauncher";
  };
}

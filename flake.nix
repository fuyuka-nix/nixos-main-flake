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
    sops-nix.url = "github:Mic92/sops-nix";
    affinity-nix.url = "github:mrshmllow/affinity-nix";
    custompkgs.url = "github:rishabh5321/custom-packages-flake";
  };
}

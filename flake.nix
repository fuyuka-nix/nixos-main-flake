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
    disko.url = "github:nix-community/disko";
    sops-nix.url = "github:Mic92/sops-nix";
    custompkgs.url = "github:rishabh5321/custom-packages-flake";
    freesm.url = "github:FreesmTeam/FreesmLauncher";
    nix-maid.url = "git+https://codeberg.org/viperML/nix-maid";
    hyprskiicursors.url = "github:fuyuka-nix/Hyprskiicursors";
    copyparty.url = "github:9001/copyparty";
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}

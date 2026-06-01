{
  description = "Packages and overlays management sub-flake";

  inputs = {
    nixpkgs = {
      type = "github";
      owner = "nixos";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };
    affinity-nix = {
      type = "github";
      owner = "mrshmllow";
      repo = "affinity-nix";
    };
    custompkgs = {
      type = "github";
      owner = "rishabh5321";
      repo = "custom-packages-flake";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      ...
    }:
    {
      inherit nixpkgs;

      systems = [
        "x86_64-linux"
      ];
      lib = import ./lib.nix { inherit (self) systems nixpkgs; };

      overlays = {
	affinity-nix = inputs.affinity-nix.overlays.default;
	default = prev: final: {
          osu-resources = final.callPackage ./osu-resources.nix { };
	  seanime = inputs.custompkgs.packages.${final.stdenv.hostPlatform.system}.seanime;
	  cdda-mods = final.callPackage ./cdda-mods { };
        };
      };

      nixosModules = import ../modules/nixos nixpkgs.lib;
      
      packages = self.lib.forAllSystems nixpkgs (pkgs: {
	cdda-mods = pkgs.callPackage ./cdda-mods { };
	osu-resources = pkgs.callPackage ./osu-resources.nix { };
      });
    };
}


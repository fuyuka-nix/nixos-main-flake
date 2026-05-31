{
  description = "Packages and overlays management sub-flake";

  inputs = {
    nixpkgs = {
      type = "github";
      owner = "nixos";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };
    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
      ref = "release-26.05";
    };
    stylix = {
      type = "github";
      owner = "nix-community";
      repo = "stylix";
      ref = "release-25.11";
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
      inherit (inputs) home-manager;

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

      nixosModules = {
        #inherit (inputs.stylix.nixosModules) stylix;
      }
      // (import ../modules/nixos nixpkgs.lib);

      homeModules = {
        #inherit (inputs.stylix.homeModules) stylix;
      }
      // (import ../modules/home nixpkgs.lib);

      #stylixModules = (import ../modules/stylix nixpkgs.lib);
      
      packages = self.lib.forAllSystems nixpkgs (pkgs: {
	cdda-mods = pkgs.callPackage ./cdda-mods { };
	osu-resources = pkgs.callPackage ./osu-resources.nix { };
      });
    };
}


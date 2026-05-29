{
  description = "Packages and overlays management sub-flake";

  inputs = {
    nixpkgs = {
      type = "github";
      owner = "nixos";
      repo = "nixpkgs";
      ref = "nixos-25.11";
    };
    nixpkgs-unstable = {
      type = "github";
      owner = "nixos";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };
    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
      ref = "release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      type = "github";
      owner = "nix-community";
      repo = "stylix";
      ref = "release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
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
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      ...
    }:
    {
      inherit nixpkgs nixpkgs-unstable;
      inherit (inputs) home-manager stylix;

      # Add all the systems your flake will support
      systems = [
        "x86_64-linux"
      ];
      eachSystem = nixpkgs.lib.genAttrs self.systems; # Extracted from the Hyprland's flake btw

      forAllSystems =
        nixpkgs-input: function: self.eachSystem (system: function (self.withSystem system nixpkgs-input));

      withSystem =
        system: nixpkgs:
        (import nixpkgs {
          inherit system;
          config.allowUnfree = true; # You migth wanna delete this, but I really hate defining predications everytime
        });

      withOverlays = overlays: { nixpkgs.overlays = overlays; };
      withAllOverlays = self.withOverlays (builtins.attrValues self.overlays);

      rememberSrcPkgs =
        pkgs: pkgsNames:
        (nixpkgs.lib.genAttrs pkgsNames (name: (self.withSystem pkgs.stdenv.hostPlatform.system nixpkgs-unstable).${name}));

      overlays = {
	affinity-nix = inputs.affinity-nix.overlays.default;
	default = prev: final:
	{
          osu-resources = final.callPackage ./osu-resources.nix { };
	  seanime = inputs.custompkgs.packages.${final.stdenv.hostPlatform.system}.seanime;
	cdda-mods = final.callPackage ./cdda-mods { };
        }
        // (self.rememberSrcPkgs final [
          "osu-lazer-bin"
          "prismlauncher"
          "inkscape"
	  "hyprland"
        ]);
      };

      nixosModules = {
        inherit (inputs.stylix.nixosModules) stylix;
      }
      // (import ../modules/nixos self.nixpkgs.lib);

      homeModules = {
        inherit (inputs.stylix.homeModules) stylix;
      }
      // (import ../modules/home self.nixpkgs.lib);

      stylixModules = (import ../modules/stylix self.nixpkgs.lib);
      
      packages = self.forAllSystems inputs.nixpkgs-unstable (pkgs:{
	cdda-mods = pkgs.callPackage ./cdda-mods { };
	osu-resources = pkgs.callPackage ./osu-resources.nix { };
      });
    };
}


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
    hyprland = {
      type = "github";
      owner = "hyprwm";
      repo = "Hyprland";
      ref = "nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    copyparty = {
      type = "github";
      owner = "9001";
      repo = "copyparty";
      inputs.nixpkgs.follows = "nixpkgs";
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
        inherit (inputs.hyprland.overlays) hyprland-packages;
        copyparty = inputs.copyparty.overlays.default;
        default = final: prev: {
          osu-resources = final.callPackage ./osu-resources.nix { };
	  seanime = inputs.custompkgs.packages.${final.stdenv.hostPlatform.system}.seanime;
        }
        // (self.rememberSrcPkgs final [
          "osu-lazer-bin"
          "prismlauncher"
          "inkscape"
        ]);
      };

      nixosModules = {
        inherit (inputs.stylix.nixosModules) stylix;
        copyparty = inputs.copyparty.nixosModules.default;
      }
      // (import ../modules/nixos self.nixpkgs.lib);

      homeModules = {
        inherit (inputs.stylix.homeModules) stylix;
      }
      // (import ../modules/home self.nixpkgs.lib);

      stylixModules = (import ../modules/stylix self.nixpkgs.lib);
    };
}


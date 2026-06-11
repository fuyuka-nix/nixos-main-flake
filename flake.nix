{
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
    sops-nix = {
      type = "github";
      owner = "Mic92";
      repo = "sops-nix";
    };
    custompkgs = {
      type = "github";
      owner = "rishabh5321";
      repo = "custom-packages-flake";
    };
  };

  outputs = inputs:
  let
    pkgs = import inputs.nixpkgs {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };
  in
  {
    nixosConfigurations = {
      pavillion = inputs.nixpkgs.lib.nixosSystem {
	inherit pkgs;
	modules = [
	  ./modules/hosts/pavillion
	  ./modules/hosts/pavillion/hardware-configuration.nix
	];
      };
    };
  };
}

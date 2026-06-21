{
  den,
  inputs,
  ...
}:
{
  den.default.includes = [
    (den.batteries.unfree [
      "affinity-extracted-sources"
      "affinity-v3"
      "steam"
      "steam-unwrapped"
      "osu-lazer-bin"
    ])
  ];
  den.default.nixos = { pkgs, ... }: {
    system.stateVersion = "26.05";
    boot = {
      loader = {
	systemd-boot.enable = true;
	systemd-boot.editor = false;
	efi.canTouchEfiVariables = true;
	timeout = 25;
      };
    };

    nix = {
      settings.auto-optimise-store = true;
      extraOptions = ''
	experimental-features = nix-command flakes pipe-operators
	keep-outputs = true
	keep-derivations = true
      '';
    };

    programs.nh = {
      enable = true;
      clean = {
	enable = true;
	extraArgs = "--keep 5 --keep-since 2d";
      };
    };

    nixpkgs.overlays = [
      inputs.affinity-nix.overlays.default
      inputs.freesm.overlays.default
      (prev: final: {
	osu-resources = pkgs.callPackage ./../../_packages/osu-resources.nix { };
	cdda-mods = pkgs.callPackage ./../../_packages/cdda-mods { };
	librewolf = pkgs.callPackage ./../../_packages/librewolf.nix { };
	seanime = inputs.custompkgs.packages.${final.stdenv.hostPlatform.system}.seanime;
      })
    ];
  };
}


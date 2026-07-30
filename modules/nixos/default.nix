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
      "osu-resources"
      "lucy-hyprcursor"
      "lucy-wincursor"
    ])
  ];
  den.default.nixos = { pkgs, ... }: {
    system.stateVersion = "26.05";
    boot = {
      loader = {
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
	osu-resources = final.callPackage ./../../_packages/osu-resources.nix { };
	cdda-mods = final.callPackage ./../../_packages/cdda-mods { };
	librewolf = final.callPackage ./../../_packages/librewolf.nix { };
	seanime = inputs.custompkgs.packages.${final.stdenv.hostPlatform.system}.seanime;
  lucy-hyprcursor = inputs.hyprskiicursors.packages.${final.stdenv.hostPlatform.system}.lucy-hyprcursor.override { inherit (final) requireFile; };
      })
    ];
  };
}


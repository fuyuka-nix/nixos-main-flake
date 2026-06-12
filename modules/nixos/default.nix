{
  den,
  ...
}:
{
  den.default.includes = [
    (den.batteries.unfree [ "affinity-nix" "steam" "steam-unwrapped" "osu-lazer-bin" ])
  ];
  den.default.nixos = {
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
  };
}


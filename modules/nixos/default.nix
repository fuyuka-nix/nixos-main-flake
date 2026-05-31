lib:
(lib.genAttrs [
  "fonts"
  "locale-es-cr"
  "pipewire"
  "steam"
  "arrpc"
] (moduleName: ./${moduleName}.nix))
// {
  starship = ./starship;
  disable-bd-prochot = ./disable-bd-prochot;
  default = {
    options = {
      modules.sysPath = lib.mkOption {
	default = "/etc/nixos";
	type = lib.types.str;
	description = "Where the flake is located in the filesystem";
      };
    };
    config = {
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
	gc = {
	  automatic = true;
	  dates = "weekly";
	  options = "--delete-older-than 7d";
	};
	extraOptions = ''
	  experimental-features = nix-command flakes pipe-operators
	  keep-outputs = true
	  keep-derivations = true
	'';
      };
    };
  };
}


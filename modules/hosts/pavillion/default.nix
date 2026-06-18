{
  inputs,
  den,
  ...
}:
{
  den.aspects.pavillion.includes = with den.aspects; [
    den.batteries.hostname
    starship.frosted-kebab
    arrpc
    disable-bd-prochot
    fonts
    locale-es-cr
    pipewire
    steam
  ];

  den.aspects.pavillion.nixos = { config, pkgs, lib, ... }: {
    imports = [
      inputs.sops-nix.nixosModules.default
      ./_hardware.nix
    ];

    sops = {
      defaultSopsFile = ./secrets/secrets.yaml;
      defaultSopsFormat = "yaml";
      age.keyFile = "/home/frozenfox/.config/sops/age/keys.txt";

      secrets = {
	"ygg/private" = { };
	"radicale-pass" = let inherit (config.services.radicale) user group; in {
	  owner = user;
	  group = group;
	};
	"syncthing-pass" = let inherit (config.services.syncthing) user group; in {
	  owner = user;
	  group = group;
	};
      };
    };

    services = {
      hypridle.enable = true;
      dbus.enable = true;
      playerctld.enable = true;
      acpid.enable = true;
      tlp.enable = true;
      upower.enable = true;

      syncthing = {
	enable = true;
	guiPasswordFile = "/run/secrets/syncthing-pass";
	overrideFolders = false;
	overrideDevices = false;
      };
    };

    programs = {
      nh.flake = "/home/frozenfox/mysystem";
      git.enable = true;
      hyprland = {
	enable = true;
	xwayland.enable = true;
	withUWSM = true;
      };
      zsh = {
	enable = true;
	enableLsColors = true;
	vteIntegration = true;
	syntaxHighlighting.enable = true;
	autosuggestions.enable = true;
      };
      hyprlock.enable = true;
      xwayland.enable = true;
      yazi.enable = true;
      vim.enable = true;
      localsend = {
	enable = true;
	openFirewall = true;
      };
      neovim = {
	enable = true;
	defaultEditor = true;
      };
    };

    environment = {
      systemPackages = with pkgs; [
	yadm

	nixd
	nil
	wl-clipboard
	inotify-tools
	brightnessctl
	mako

	quickshell
	rose-pine-hyprcursor
	hyprlauncher
	hyprsunset
	hyprpaper
	hyprpicker
	hyprshot
	kitty
	fastfetch

	p7zip
	imagemagick
	ripgrep
	btop

	crosspipe
	easyeffects
	pavucontrol

	librewolf
	tor-browser
      ];
      sessionVariables = {
	HYPRCURSOR_THEME = "rose-pine-hyprcursor";
	# Hyprland specific variables are defined at ~/.config/uwsm/env-hyprland (yadm)
      };
    };

    hardware = {
      bluetooth.enable = true;
      graphics.enable = true;
    };

    fileSystems = {
      "/" = {
	device = "/dev/disk/by-uuid/02672b4c-3a47-4cad-a086-6707475ad0d4";
	fsType = "btrfs";
	options = [
	  "subvol=@"
	  "compress=lzo"
	];
      };

      "/boot" = {
	device = "/dev/disk/by-uuid/68DA-21E0";
	fsType = "vfat";
	options = [
	  "fmask=0077"
	  "dmask=0077"
	];
      };

      "/mnt/ssdsata" = {
	device = "/dev/disk/by-uuid/b43e0502-b5ed-4498-b491-c66fa78bddfe";
	fsType = "btrfs";
	options = [
	  "nofail"
	];
      };
    };
  };
}

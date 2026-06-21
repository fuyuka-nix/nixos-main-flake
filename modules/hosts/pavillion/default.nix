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
      ./_hardware.nix
    ];

    boot.loader.limine = {
      enable = true;
      style = {
	#wallpapers = [];
	wallpaperStyle = "centered";
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
	#enable = true;
	guiPasswordFile = "/run/secrets/syncthing-pass";
	overrideFolders = false;
	overrideDevices = false;
      };
    };

    programs = {
      nh.flake = "/home/frozenfox/Desktop/nixos-main-flake";
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
	sops
	yadm

	sbctl
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

	tor-browser
	librewolf
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
    /*
    "/mnt/ssdsata" = {
      device = "/dev/disk/by-uuid/b43e0502-b5ed-4498-b491-c66fa78bddfe";
      fsType = "btrfs";
      options = [
        "nofail"
      ];
    };
    */
  };
}

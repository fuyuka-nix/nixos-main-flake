{
  den,
  ...
}:
{
  den.aspects.frozenfox = {
    maid = {
      file.home = {
	".zshrc".source = ./zshrc;
      };

      dconf.settings = {
	"/org/gnome/desktop/interface/color-scheme" = "prefer-dark";
	"/org/gnome/desktop/interface/icon-theme" = "Adwaita";
      };
    };
  };
  den.aspects.pavillion.nixos = { pkgs, ... }: {
    nix.settings.allowed-users = [ "frozenfox" ];
    users.defaultUserShell = pkgs.zsh;

    users.users.frozenfox = {
      useDefaultShell = true;
      isNormalUser = true;
      initialPassword = "12345"; # change with "passwd [user]"
      extraGroups = [
	"input"
	"wheel"
	"networkmanager"
      ];
      packages = with pkgs; [
	android-tools
	gh
	jq
	tmux
	sops
	keepassxc

	affinity-v3
	libresprite
	libreoffice
	obs-studio

	simplex-chat-desktop
	thunderbird
	dino
	joplin-desktop
	monero-gui

	anki
	seanime
	heroic
	vlc
	mpv

	osu-lazer-bin
	freesmlauncher
	ryubing
	(cataclysm-dda.withMods (_: with cdda-mods; [
	  cc-sounds
	]))
      ];
    };
  };
}

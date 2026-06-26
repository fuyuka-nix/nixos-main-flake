{
  pkgs,
  den,
  ...
}:
{
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
	(cataclysm-dda.withMods (_: with cdda-mods; [
	  cc-sounds
	]))
      ];
    };
  };
}

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
      extraGroups = [
	"input"
	"wheel"
	"networkmanager"
	"syncthing"
      ];
      packages = with pkgs; [
	android-tools
	gh
	jq
	tmux
	sops

	affinity-v3
	libresprite
	libreoffice
	obs-studio

	simplex-chat-desktop
	thunderbird
	joplin-desktop

	anki
	seanime
	heroic
	vlc

	osu-lazer-bin
	prismlauncher
	(cataclysm-dda.withMods (_: with cdda-mods; [
	  cc-sounds
	]))
      ];
    };
  };
}

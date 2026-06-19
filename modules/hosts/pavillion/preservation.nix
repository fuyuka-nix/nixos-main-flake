{
  den,
  inputs,
  ...
}:
{
  den.aspects.pavillion.nixos = {
    imports = [ inputs.preservation.nixosModules.default ];

    boot.tmp.cleanOnBoot = true;
    
    fileSystems = {
      "/nix".neededForBoot = true;
      "/persistent".neededForBoot = true;
    };

    preservation = {
      enable = true;

      preserveAt."/persistent" = {
        files = [
          { file = "/etc/machine-id"; inInitrd = true; }
        ];
        directories = [
          # recommended
          "/var/lib/systemd/timers"
          "/var/lib/nixos"
          "/var/log"
          # extras
          "/var/lib/bluetooth"
          "/etc/NetworkManager/system-connections"
          "/etc/nixos"
        ];

        users.frozenfox = {
          files = [];
          directories = [
            ".local/state/wireplumber"
            ".ssh"
	    ".zshrc"
	    ".histfile"
            ".config/sops"
            ".config/hypr"
            ".config/yadm"
            ".config/kitty"
            ".config/gh"
	    ".config/Joplin"
	    ".config/joplin"
	    ".config/joplin-desktop"
	    ".config/simplex"
	    ".config/quickshell"
	    ".config/librewolf"
	    ".config/mako"
	    ".config/nvim"
	    ".config/monero-project"
	    ".config/heroic"
	    ".config/easyeffects"
	    ".config/StardewValley"
	    ".config/Seanime"
	    ".config/uwsm"
            ".gnupg"
            ".bitmonero"
            ".cataclysm-dda"
            ".thunderbird"
            "Documents"
            "Downloads"
            "Desktop"
            "Pictures"
            "Music"
            "Videos"
          ];
        };
      };
    };
  };
}

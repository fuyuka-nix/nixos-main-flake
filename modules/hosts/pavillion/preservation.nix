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
          files = [
	    ".zshrc"
	    ".histfile"
	  ];
          directories = [
            ".local/state/wireplumber"
            ".ssh"
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
	    ".local/share/simplex"
	    ".local/share/yadm"
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

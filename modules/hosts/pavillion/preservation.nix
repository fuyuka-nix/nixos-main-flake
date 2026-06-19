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

    systemd.services.systemd-machine-id-commit = {
      unitConfig.ConditionPathIsMountPoint = [
	""
	"/persistent/etc/machine-id"
      ];
      serviceConfig.ExecStart = [
	""
	"systemd-machine-id-setup --commit --root /persistent"
      ];
    };

    preservation = {
      enable = true;

      preserveAt."/persistent" = {
        files = [
          {
	    file = "/etc/machine-id";
	    inInitrd = true;
	    how = "symlink";
	    configureParent = true;
	  }
        ];
        directories = [
	  { directory = "/run/secrets"; inInitrd = true; }
          "/var/lib/systemd/timers"
          "/var/lib/nixos"
          "/var/log"
          "/var/lib/bluetooth"
          "/etc/NetworkManager/system-connections"
          "/etc/nixos"
        ];

        users.frozenfox = {
          files = [
	    ".zshrc"
	  ];
          directories = [
	    { directory = ".ssh"; mode = "0700"; }
            { directory = ".config/sops"; inInitrd = true; }
            { directory = ".gnupg"; inInitrd = true; }
            ".local/state/wireplumber"
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

    systemd.tmpfiles.settings.preservation = let
      use-as = { user = "frozenfox"; group = "users"; mode = "0755"; };
    in {
      "/home/frozenfox/.config".d = use-as;
      "/home/frozenfox/.local".d = use-as;
      "/home/frozenfox/.local/share".d = use-as;
      "/home/frozenfox/.local/state".d = use-as;
    };
  };
}

{
  den,
  inputs,
  ...
}:
{
  den.aspects.pavillion.nixos = { config, ... }: {
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
	  {
	    file = "/var/secrets/ygg/private";
	    mode = "0700";
	  }
	  {
	    file = "/var/secrets/radicale-pass";
	    mode = "0700";
	    inherit (config.services.radicale) user group;
	  }
        ];
        directories = [
	  {
	    directory = "/var/lib/radicale";
	    inherit (config.services.radicale) user group;
	  }
          "/var/lib/systemd/timers"
          "/var/lib/nixos"
          "/var/lib/bluetooth"
	  "/var/lib/sbctl"
          "/var/log"
          "/etc/NetworkManager/system-connections"
          "/etc/nixos"
        ];

        users.frozenfox = {
          files = [
	    ".zshrc"
	  ];
          directories = [
	    { directory = ".ssh"; mode = "0700"; }
            { directory = ".config/sops"; inInitrd = true; mode = "0700"; }
            { directory = ".gnupg"; inInitrd = true; }
	    ".cache"
	    ".android"
	    ".local/share"
            ".local/state/wireplumber"
            ".config/hypr"
            ".config/yadm"
            ".config/kitty"
            ".config/gh"
	    ".config/Joplin"
	    ".config/joplin"
	    ".config/joplin-desktop"
	    "JoplinBackup"
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
            ".bitmonero"
	    "Monero"
            ".cataclysm-dda"
            ".thunderbird"
	    ".tor"
	    ".tor project"
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

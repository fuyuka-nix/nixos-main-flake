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
          "/tmp"
        ];

        users.frozenfox = {
          files = [];
          directories = [
            ".local/state/wireplumber"
            ".ssh"
            ".config/sops"
            ".config/hypr"
            ".config/yadm"
            ".config/kitty"
            ".config/gh"
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

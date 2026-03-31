{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./copyparty.nix
  ];

  modules.starship.frosted-kebab.enable = true;

  system.stateVersion = "25.11";

  nix.settings.allowed-users = [ "frozenfox" ];
  users.users.frozenfox = {
    isNormalUser = true;
    extraGroups = [
      "input"
      "wheel"
      "networkmanager"
    ];
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  environment = {
    systemPackages = with pkgs; [
      luajitPackages.luarocks
      vim
      home-manager
      nixd
      nil
      p7zip
      imagemagick
      helvum
      inotify-tools
      vesktop
      librewolf
      tor-browser
      obs-studio
      simplex-chat-desktop
    ];
    # sessionVariables = {
    # NIXOS_OZONE_WL = "1";
    # PASSWORD_STORE_DIR = "$HOME/.local/share/password-store";
    # };
  };

  networking = {
    networkmanager.enable = true;
    hostName = "Pavillion-Laptop";
    firewall.enable = true;
  };

  hardware = {
    bluetooth.enable = false;
    graphics.enable = true;
  };
  fileSystems = {
    "/".options = [
      "compress=lzo"
    ];
    "/mnt/mclauncher" = {
      inherit (config.fileSystems."/") device fsType;
      options = [
        "compress=lzo"
        "subvol=mclauncher"
      ];
    };
    "/mnt/keys" = {
      inherit (config.fileSystems."/") device fsType;
      options = [
        "compress=lzo"
        "subvol=keys"
      ];
    };
    "/mnt/ssdsata" = {
      device = "/dev/disk/by-uuid/b43e0502-b5ed-4498-b491-c66fa78bddfe";
      fsType = "btrfs";
      options = [ "nofail" ];
    };
    "mnt/copyparty" = {
      inherit (config.fileSystems."/mnt/ssdsata") device fsType;
      options = [
        "compress=lzo"
        "subvol=copyparty"
      ];
    };
    "mnt/steam" = {
      inherit (config.fileSystems."/mnt/ssdsata") device fsType;
      options = [
        "compress=lzo"
        "subvol=steam"
      ];
    };
  };
}

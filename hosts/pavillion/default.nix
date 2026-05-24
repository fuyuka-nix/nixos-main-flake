{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./users.nix
    ./networking.nix
  ];

  modules.starship.frosted-kebab.enable = true;

  system.stateVersion = "25.11";
  boot.enableContainers = true;

  services = {
    hypridle.enable = true;
    dbus.enable = true;
    playerctld.enable = true;
    acpid.enable = true;
    tlp.enable = true;
    upower.enable = true;
    displayManager.ly.enable = true;
  };

  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    hyprlock.enable = true;
    dconf.enable = true;
    xwayland.enable = true;
    yazi.enable = true;
    zsh.enable = true;
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
      home-manager
      yadm

      nixd
      nil
      wl-clipboard
      inotify-tools
      brightnessctl

      quickshell
      rose-pine-hyprcursor
      hyprlauncher
      hyprsunset
      hyprpicker
      hyprshot
      kitty
      fastfetch

      p7zip
      imagemagick
      ripgrep
      btop

      helvum
      easyeffects
      pavucontrol

      librewolf
      tor-browser

    ];
    sessionVariables = {
      #NIXOS_OZONE_WL = "1";
      #PASSWORD_STORE_DIR = "$HOME/.local/share/password-store";
      XCURSOR_SIZE = "24";
      HYPRCURSOR_SIZE = "24";
      HYPRCURSOR_THEME = "rose-pine-hyprcursor";
      GDK_BACKEND = "wayland";
      ROOT_FLAKE = config.modules.sysPath;
    };
  };

  hardware = {
    bluetooth.enable = true;
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
    "/mnt/ssdsata" = {
      device = "/dev/disk/by-uuid/b43e0502-b5ed-4498-b491-c66fa78bddfe";
      fsType = "btrfs";
      options = [ "nofail" ];
    };
    "mnt/steam" = {
      inherit (config.fileSystems."/mnt/ssdsata") device fsType;
      options = [
        "compress=lzo"
        "subvol=steam"
      ];
    };
    "mnt/nextcloud" = {
      inherit (config.fileSystems."/mnt/ssdsata") device fsType;
      options = [
        "compress=lzo"
        "subvol=nextcloud"
      ];
    };
  };
}

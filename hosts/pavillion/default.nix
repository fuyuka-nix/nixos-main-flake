{
  pkgs,
  lib,
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
  };

  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
    };
    uwsm.waylandCompositors.hyprland = lib.mkForce {
      prettyName = "hyprland";
      binPath = "/run/current-system/sw/bin/start-hyprland";
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
      hyprpaper
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
      HYPRCURSOR_THEME = "rose-pine-hyprcursor";
      ROOT_FLAKE = config.modules.sysPath;
      # Hyprland specific variables are defined at ~/.config/uwsm/env-hyprland (yadm)
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

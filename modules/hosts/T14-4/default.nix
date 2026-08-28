{
  inputs,
  den,
  ...
}:
{
  den.aspects.T14-4.includes = with den.aspects; [
    den.batteries.hostname
    arrpc
    fonts
    locale-es-cr
    pipewire
    steam
    yggdrasil
  ];

  den.aspects.T14-4.nixos = { config, lib, pkgs, ... }: {
    imports = [
      ./_hardware.nix
      inputs.sops-nix.nixosModules.sops
    ];

    sops = {
      defaultSopsFile = ./secrets/secrets.yaml;
      defaultSopsFormat = "yaml";
      age = {
        keyFile = "/home/foxnix/.config/sops/age/keys.txt";
      };
      secrets = {
        "ygg/private" = {};
        "nextcloud/admin" = {};
      };
    };

    boot.loader.limine = {
      enable = true;
      secureBoot = {
        enable = true;
        autoGenerateKeys = true;
        autoEnrollKeys.enable = true;
      };
      style = {
        wallpapers = [
          "${pkgs.osu-resources}/share/osu-resources/Textures/Backgrounds/registration.jpg"
        ];
        wallpaperStyle = "centered";
      };
    };

    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    services.usbmuxd.enable = true;

    programs = {
      nh.flake = "/etc/nixos";
      git.enable = true;
      zsh = {
        enable = true;
        enableLsColors = true;
        syntaxHighlighting.enable = true;
        autosuggestions.enable = true;
      };
      hyprland = {
        enable = true;
        xwayland.enable = true;
        withUWSM = true;
      };
      hyprlock.enable = true;
      localsend = {
        enable = true;
        openFirewall = true;
      };
      yazi.enable = true;
      vim = {
        enable = true;
        defaultEditor = true;
      };
    };

    services = {
      hypridle.enable = true;
      dbus.enable = true;
      playerctld.enable = true;
      acpid.enable = true;
      upower.enable = true;
      qbittorrent = {
        enable = true;
        openFirewall = true;
        torrentingPort = 40087;
        webuiPort = 4088;
      };
    };

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    services.openssh.enable = true;

    environment.systemPackages = with pkgs; [
      wget
      fastfetch
      btop
      kitty
      sbctl
      brightnessctl
      mako
      p7zip
      imagemagick
      ffmpeg
      ripgrep
      (bottles.override { removeWarningPopup = true; })
      crosspipe
      easyeffects
      pavucontrol
      tor-browser # firejailed
      zen-browser # firejailed
      ckan
      bat
      graphite
    ];
  };
}


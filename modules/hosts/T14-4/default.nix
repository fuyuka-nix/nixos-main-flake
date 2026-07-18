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
      };
    };

    boot.loader.limine = {
      enable = true;
      secureBoot.enable = true;
      style = {
        #wallpapers = [];
        wallpaperStyle = "centered";
      };
    };

    ygg.prefix = "300:3467:ae65:977a";
    ygg.address = "200:3467:ae65:977a:be15:dd9a:53c4:6964";
    services.yggdrasil.settings.IfName = "ygg0";

    networking.networkmanager.enable = true;

    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

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
    };

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    services.openssh.enable = true;

    services.fprintd.enable = true;

    environment.systemPackages = with pkgs; [
      wget
      fastfetch
      btop
      kitty
      sbctl
      lynis
      nixd
      nil
      wl-clipboard
      inotify-tools
      brightnessctl
      mako
      quickshell
      rose-pine-hyprcursor
      hyprlauncher
      hyprsunset
      hyprpaper
      hyprpicker
      hyprshot
      p7zip
      imagemagick
      ripgrep
      crosspipe
      easyeffects
      pavucontrol
      tor-browser
      librewolf
      yadm
      nix-update
      hyprshutdown
    ];
  };
}


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
      secureBoot.enable = true;
      style = {
        #wallpapers = [];
        wallpaperStyle = "centered";
      };
    };

    ygg.address = "202:bf3d:9ff8:9cc:24d3:4fb6:c263:f32e";
    ygg.prefix = "302:bf3d:9ff8:9cc";
    services.yggdrasil = {
      settings = {
        IfName = "ygg0";
        Listen = [
          "tcp://[::]:8080"
          "ws://[::]:4442"
        ];
        PrivateKeyPath = "/run/secrets/ygg/private";
      };
    };

    networking.networkmanager.enable = true;
    networking.firewall = {
      logRefusedPackets = true;
      interfaces.${config.services.yggdrasil.settings.IfName}.allowedTCPPorts = [ 8080 4442 ];
    };

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


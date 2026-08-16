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

    boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;

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

    ygg.address = "200:a09d:7102:3805:8e3d:4ed8:833c:d932";
    ygg.prefix = "300:a09d:7102:3805";
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

    vhosts.seanime = {
      localPort = 43211;
    };
    services.nginx.virtualHosts."${config.vhosts.seanime.ygg}".locations."/".proxyWebsockets = true;

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
      i2pd = {
        enable = true;
        proto = {
          http.enable = true;
          httpProxy.enable = true;
          socksProxy.enable = true;
          sam.enable = true;
          i2cp = {
            enable = true;
            address = "127.0.0.1";
            port = 7654;
          };
        };
      };
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
      lynis
      brightnessctl
      mako
      p7zip
      imagemagick
      ripgrep
      crosspipe
      easyeffects
      pavucontrol
      tor-browser
      zen-browser
      ckan
    ];
  };
}


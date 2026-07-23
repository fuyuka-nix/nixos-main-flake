{
  den,
  ...
}:
{
  den.aspects.foxnix = {
    maid = {
      file.home = {
        ".zshrc".source = ./zshrc;
      };

      dconf.settings = {
        "/org/gnome/desktop/interface/color-scheme" = "prefer-dark";
        "/org/gnome/desktop/interface/icon-theme" = "Adwaita";
      };
    };
  };
  den.aspects.T14-4.nixos = { pkgs, ... }: {
    nix.settings.allowed-users = [ "foxnix" ];
    users.defaultUserShell = pkgs.zsh;

    users.users.foxnix = {
      useDefaultShell = true;
      isNormalUser = true;
      initialPassword = "12345"; # change with "passwd [user]"
      extraGroups = [
        "wheel"
        "networkmanager"
        "canner"
      ];
      packages = with pkgs; [
        wl-clipboard
        inotify-tools
        android-tools
        sops
        keepassxc

        yadm
        quickshell
        rose-pine-hyprcursor
        hyprlauncher
        hyprsunset
        hyprpaper
        hyprpicker
        hyprshot
        hyprshutdown

        affinity-v3
        libresprite
        libreoffice
        obs-studio

        simplex-chat-desktop
        thunderbird
        monero-gui

        seanime
        mpv
      ];
    };
  };
}

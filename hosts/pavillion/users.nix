{
  pkgs,
  ...
}:
{
  nix.settings.allowed-users = [ "frozenfox" ];
  users.defaultUserShell = pkgs.zsh;

  users.users.frozenfox = {
    useDefaultShell = true;
    isNormalUser = true;
    extraGroups = [
      "input"
      "wheel"
      "networkmanager"
    ];
    packages = with pkgs; [
      jq
      mpv
      btop
      fastfetch
      hyprshot
      youtube-music
      wl-clicker
      lutris
      winetricks
      osu-lazer-bin
      prismlauncher
      gh
      hyprpicker
      cava
      inkscape
      brightnessctl
      libresprite
      libreoffice
      heroic
      anki
      affinity-v3
    ];
  };
}

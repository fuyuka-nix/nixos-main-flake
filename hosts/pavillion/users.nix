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
      android-tools
      gh
      jq
      tmux

      affinity-v3
      libresprite
      libreoffice
      obs-studio

      simplex-chat-desktop
      thunderbird
      joplin-desktop

      anki
      seanime
      heroic
      youtube-music
      vlc

      cataclysm-dda
      osu-lazer-bin
      prismlauncher
    ];
  };
}

{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./anki.nix
  ];

  programs = {
    jq.enable = true;
    mpv.enable = true;
  };

  home.homeDirectory = "/home/${config.home.username}";
  home.packages = with pkgs; [
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
  ];

  programs.zsh.shellAliases = {
    nixos-rsrf = "sudo nixos-rebuild switch --flake ~/mysystem/#pavillion";
    nixos-rbrf = "sudo nixos-rebuild boot --flake ~/mysystem/#pavillion";
    home-srf = "home-manager switch --flake ~/mysystem/#frozenfox";
  };
}

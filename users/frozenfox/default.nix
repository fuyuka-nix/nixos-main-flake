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

  programs.zsh.shellAliases =
  let
    rf = "~/mysystem/#pavillion";
  in
  {
    nixos-rsrf = "sudo nixos-rebuild switch --flake ${rf}";
    nixos-rbrf = "sudo nixos-rebuild boot --flake ${rf}";
    nixos-rdrrf = "sudo nixos-rebuild dry-run --flake ${rf}";
    home-msrf = "home-manager switch --flake ${rf}";
    nix-home-rsrf = "sudo nixos-rebuild switch --flake ${rf}; home-manager switch --flake ${rf}";
    kitty-d1 = "kitty --detach -1";
    kitty-d = "kitty --detach";
  };
}

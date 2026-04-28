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
    rf = "~/mysystem/#";
    su-nixos-r = "sudo nixos-rebuild";
  in
  {
    nixos-rsrf = "${su-nixos-r} switch --flake ${rf}pavillion";
    nixos-rbrf = "${su-nixos-r} boot --flake ${rf}pavillion";
    nixos-rdrrf = "${su-nixos-r} dry-run --flake ${rf}pavillion";
    nixos-testrf = "${su-nixos-r} test --flake ${rf}pavillion";
    home-msrf = "home-manager switch --flake ${rf}frozenfox";
    nix-home-rsrf = "${su-nixos-r} switch --flake ${rf}pavillion; home-manager switch --flake ${rf}frozenfox";
    kitty-d1 = "kitty --detach -1";
    kitty-d = "kitty --detach";
  };
}

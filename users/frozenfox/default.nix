{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./anki.nix
  ];

  stylix.targets.hyprland.enable = false;

  services = {
    easyeffects.enable = true;
    hyprpaper.enable = true;
  };

  programs = {
    osu-resources.enable = true;
  };

  home.homeDirectory = "/home/${config.home.username}";

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

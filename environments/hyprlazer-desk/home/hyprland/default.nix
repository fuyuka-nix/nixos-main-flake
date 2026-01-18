{
  pkgs,
  config,
  lib,
  ...
}:
let
  palette = config.lib.stylix.colors;
in
{
  services = {
    hypridle.enable = true;
    hyprpaper.enable = true;
  };

  programs = {
    hyprshot.enable = true;
  };

  stylix.targets.hyprland.enable = false;

  home.packages = with pkgs; [
    wofi
    wl-clipboard
  ];
}

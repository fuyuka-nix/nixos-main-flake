{
  pkgs,
  lib,
  ...
}:
{
  services = {
    hypridle.enable = true;
    hyprpaper.enable = true;
  };

  programs = {
    hyprshot.enable = true;
  };

  stylix.targets.hyprland.enable = false;
}

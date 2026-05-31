{
  pkgs,
  config,
  ...
}:
{
  #stylix.targets.hyprland.enable = false;

  services = {
    easyeffects.enable = true;
    hyprpaper.enable = true;
  };

  home.homeDirectory = "/home/${config.home.username}";
}

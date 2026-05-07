{
  pkgs,
  ...
}:
{
  systemd.user.services.hyprpaper = {
    name = "hyprpaper.service";
    description = "hyprpaper (duh)";
    after = [ config.wayland.systemd.target ];
    partOf = [ config.wayland.systemd.target ];
    wantedBy = [ "graphical-session.target" ];
    path = with pkgs; [
      hyprland
      hyprpaper
    ];
    reloadIfChanged = true;
    stopIfChanged = true;
    script = "hyprpaper"
  };
}

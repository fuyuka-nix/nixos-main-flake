{
  pkgs,
  ...
}:
{
  systemd.user.services.hyprpaper = {
    name = "hyprpaper.service";
    description = "hyprpaper (duh)";
    wantedBy = [ "graphical-session.target" ];
    path = with pkgs; [
      hyprland
      hyprpaper
    ];
    reloadIfChanged = true;
    stopIfChanged = true;
    script = "hyprpaper";
  };
}

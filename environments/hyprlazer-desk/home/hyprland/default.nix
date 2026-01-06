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
  imports = [
    ./binds.nix
  ];

  services = {
    hypridle.enable = true;
    hyprpaper.enable = true;
  };

  programs = {
    hyprshot.enable = true;
  };

  stylix.targets.hyprland.enable = false;
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;
    extraConfig = builtins.readFile ./hyprland.conf;
    submaps = {
      "Screenshot".settings = {
        bind = [
          ", PRINT, exec, hyprshot -m region -z --clipboard-only ; hyprctl dispatch submap reset"
          ", escape, submap, reset"
        ];
      };
    };
    settings = {
      "$terminal" = "kitty";

      general = lib.mkForce {
        "col.inactive_border" = "rgb(${palette.base00})";
        "col.active_border" = "rgb(${palette.base04})";
      };
    };
  };

  home.packages = with pkgs; [
    wofi
    wl-clipboard
  ];
}

{
  pkgs,
  ...
}:
{
  imports = [
    ./yazi
  ];

  security = {
    polkit.enable = true;
  };

  services = {
    hypridle.enable = true;
    dbus.enable = true;
    playerctld.enable = true;
    acpid.enable = true;
    tlp.enable = true;
    displayManager.ly = {
      enable = true;
    };
  };

  xdg.portal = {
    enable = true;
    config.common.default = [ "hyprland" ];
    extraPortals = with pkgs; [
      xdg-desktop-portal-cosmic
    ];
    configPackages = with pkgs; [
      xdg-desktop-portal-hyprland
    ];
  };

  users.defaultUserShell = pkgs.zsh;
  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    hyprlock.enable = true;
    dconf.enable = true;
    xwayland.enable = true;
    zsh.enable = true;
    localsend = {
      enable = true;
      openFirewall = true;
    };
  };

  environment.systemPackages = with pkgs; [
    rose-pine-hyprcursor
    ripgrep
    wl-clipboard
    wofi
    rofi
    kitty
    exercism
    yadm
  ];

  environment.sessionVariables = {
    XCURSOR_SIZE = "24";
    HYPRCURSOR_SIZE = "24";
    HYPRCURSOR_THEME = "rose-pine-hyprcursor";
    GDK_BACKEND = "wayland";
    EDITOR = "nvim";
  };
}

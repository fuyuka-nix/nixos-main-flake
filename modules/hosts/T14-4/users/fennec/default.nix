{
  den,
  ...
}:
{
  den.aspects.fennec = {
    maid = {
      dconf.settings = {
        "/org/gnome/desktop/interface/color-scheme" = "prefer-dark";
        "/org/gnome/desktop/interface/icon-theme" = "Adwaita";
      };
    };
  };
  den.aspects.T14-4.nixos = { pkgs, ... }: {
    users.users.fennec = {
      useDefaultShell = true;
      isNormalUser = true;
      initialPassword = "12345";
      extraGroups = [
        "canner"
      ];
      packages = with pkgs; [
        heroic
        bottles
        ckan
      ];
    };
  };
}

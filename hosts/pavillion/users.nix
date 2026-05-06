{
  pkgs,
  ...
}:
{
  nix.settings.allowed-users = [ "frozenfox" ];
  users.defaultUserShell = pkgs.zsh;

  users.users.frozenfox = {
    isNormalUser = true;
    extraGroups = [
      "input"
      "wheel"
      "networkmanager"
    ];
  };
}

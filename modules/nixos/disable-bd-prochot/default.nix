{
  pkgs,
  ...
}:
let
  script = builtins.readFile ./script.sh;
in
{
  # Credits to https://github.com/fralapo/Disable-BD-PROCHOT-on-LINUX
  systemd.services.disable-bd-prochot = {
    enable = true;
    after = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];
    path = with pkgs; [ msr msr-tools ];
    inherit script;
  };

  systemd.services.resume-disable-db-prochot = {
    enable = true;
    after = [ "suspend.target" "hibernate.target" "hybrid-sleep.target" "suspend-then-hibernate.target" ];
    wantedBy = [ "suspend.target" "hibernate.target" "hybrid-sleep.target" "suspend-then-hibernate.target" ];
    path = with pkgs; [ msr msr-tools ];
    inherit script;
  };
}

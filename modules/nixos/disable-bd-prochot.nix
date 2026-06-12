{
  den,
  ...
}:
let
  script = ''
    #!/bin/bash
    set -e
    modprobe msr 2>/dev/null || true
    for cpu in /dev/cpu/[0-9]*; do
	cpu_id="$\{cpu##*/cpu/\}"; cpu_id="$\{cpu_id%%/*\}"
	cur=$(rdmsr -p "$cpu_id" 0x1FC)
	new=$(( 16#$cur & ~1 ))
	wrmsr -p "$cpu_id" 0x1FC "$(printf '0x%x' "$new")"
    done
  '';
in
{
  # Credits to https://github.com/fralapo/Disable-BD-PROCHOT-on-LINUX
  den.aspects.disable-bd-prochot.nixos = { pkgs, ... }: {
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
  };
}

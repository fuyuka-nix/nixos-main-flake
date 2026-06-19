{
  den,
  ...
}:
let
  script = ''
    #!/bin/bash
    modprobe msr 2>/dev/null || true
    shopt -s nullglob
    cpus=(/dev/cpu/[0-9]*)
    [ ''${#cpus[@]} -eq 0 ] && { logger -t disable_bd_prochot "no /dev/cpu/*/msr"; exit 1; }
    fail=0
    for cpu in "''${cpus[@]}"; do
        cpu_id="''${cpu##*/cpu/}"; cpu_id="''${cpu_id%%/*}"
        cur=$(rdmsr -p "$cpu_id" 0x1FC 2>/dev/null) || { logger -t disable_bd_prochot "rdmsr failed on cpu $cpu_id"; fail=1; continue; }
        (( 16#$cur & 1 )) || continue        # bit 0 already clear
        new=$(( 16#$cur & ~1 ))
        wrmsr -p "$cpu_id" 0x1FC "$(printf '0x%x' "$new")" 2>/dev/null || { logger -t disable_bd_prochot "wrmsr failed on cpu $cpu_id (kernel lockdown?)"; fail=1; continue; }
        chk=$(rdmsr -p "$cpu_id" 0x1FC 2>/dev/null)
        (( 16#$chk & 1 )) && { logger -t disable_bd_prochot "wrmsr on cpu $cpu_id did not persist (firmware/EC re-asserting)"; fail=1; }
    done
    exit $fail
  '';
in
{
  # Credits to https://github.com/fralapo/Disable-BD-PROCHOT-on-LINUX
  den.aspects.disable-bd-prochot.nixos = { pkgs, ... }: {
    boot.kernelModules = [ "msr" ];
    systemd.services.disable-bd-prochot = {
      enable = true;
      after = [ "multi-user.target" ];
      wantedBy = [ "multi-user.target" ];
      path = with pkgs; [ msr msr-tools logger ];
      inherit script;
    };

    systemd.services.resume-disable-db-prochot = {
      enable = true;
      after = [ "suspend.target" "hibernate.target" "hybrid-sleep.target" "suspend-then-hibernate.target" ];
      wantedBy = [ "suspend.target" "hibernate.target" "hybrid-sleep.target" "suspend-then-hibernate.target" ];
      path = with pkgs; [ msr msr-tools logger ];
      inherit script;
    };
  };
}

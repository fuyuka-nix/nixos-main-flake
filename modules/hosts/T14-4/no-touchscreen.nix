{
  den,
  ...
}:
{
  den.aspects.T14-4.nixos = { pkgs, ... }: {
    systemd.services.no-touchscreen = {
      description = "Disable T14 gen 4's touchscreen at boot";
      wantedBy = [ "multi-user.target" ];
      path = with pkgs; [ coreutils util-linux findutils ];
      script = ''
        #!/bin/bash
        set -euo pipefail 
        devdir=/sys/bus/hid/drivers/hid-multitouch
        pattern="0018:2A94:A819."
        shopt -s nullglob
        matches=("$devdir"/"$pattern"*)

        if [ "''${#matches[@]}" -eq 0 ]; then
          echo "No matches for $pattern"
          exit 0
        fi

        for m in "''${matches[@]}"; do
          echo "Unbinding $(basename "$m")"
          echo "$(basename "$m")" | tee "$devdir/unbind" >/dev/null
        done
        exit 0
      '';

      serviceConfig = {
        Type = "oneshot";
        User = "root";
        Group = "root";
      };
    };
  };
}

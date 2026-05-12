  #!/bin/bash
  set -e
  modprobe msr 2>/dev/null || true
  for cpu in /dev/cpu/[0-9]*; do
      cpu_id="${cpu##*/cpu/}"; cpu_id="${cpu_id%%/*}"
      cur=$(rdmsr -p "$cpu_id" 0x1FC)
      new=$(( 16#$cur & ~1 ))
      wrmsr -p "$cpu_id" 0x1FC "$(printf '0x%x' "$new")"
  done

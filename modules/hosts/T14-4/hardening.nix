{
  den,
  ...
}:
{
  den.aspects.T14-4.nixos = { pkgs, ... }: {
    boot = {
      kernelPackages = pkgs.linux_hardened;
      blacklistedKernelModules = [
        # Obscure network protocols
        "ax25" "netrom" "rose"

        # Old or rare or insufficiently audited filesystems
        "adfs" "affs"
        "bfs" "befs"
        "cramfs"
        "efs" "erofs" "exofs"
        "freevxfs" "f2fs"
        "hfs" "hpfs"
        "jfs"
        "minix"
        "nilfs2" "ntfs"
        "omfs"
        "qnx4" "qnx6"
        "sysv"
        "ufs"
      ];
      kernelParams = [
        # Don't merge slabs
        "slab_nomerge"

        # Overwrite free'd pages
        "page_poison=1"

        # Enable page allocator randomization
        "page_alloc.shuffle=1"

        # Disable debugfs
        "debugfs=off"
      ];
      kernel.sysctl = {
        # Hide kptrs even for processes with CAP_SYSLOG
        "kernel.kptr_restrict" = "2";

        # Disable bpf() JIT (to eliminate spray attacks)
        "net.core.bpf_jit_enable" = false;

        # Disable ftrace debugging
        "kernel.ftrace_enabled" = false;

        # Disable io_uring, a large source of security vulnerabilities
        # https://security.googleblog.com/2023/06/learnings-from-kctf-vrps-42-linux.html
        "kernel.io_uring_disabled" = 2;

        # Enable strict reverse path filtering (that is, do not attempt to route
        # packets that "obviously" do not belong to the iface's network; dropped
        # packets are logged as martians).
        "net.ipv4.conf.all.log_martians" = true;
        "net.ipv4.conf.all.rp_filter" = "1";
        "net.ipv4.conf.default.log_martians" = true;
        "net.ipv4.conf.default.rp_filter" = "1";

        # Ignore broadcast ICMP (mitigate SMURF)
        "net.ipv4.icmp_echo_ignore_broadcasts" = true;

        # Ignore incoming ICMP redirects (note: default is needed to ensure that the
        # setting is applied to interfaces added after the sysctls are set)
        "net.ipv4.conf.all.accept_redirects" = false;
        "net.ipv4.conf.all.secure_redirects" = false;
        "net.ipv4.conf.default.accept_redirects" = false;
        "net.ipv4.conf.default.secure_redirects" = false;
        "net.ipv6.conf.all.accept_redirects" = false;
        "net.ipv6.conf.default.accept_redirects" = false;

        # Ignore outgoing ICMP redirects (this is ipv4 only)
        "net.ipv4.conf.all.send_redirects" = false;
        "net.ipv4.conf.default.send_redirects" = false;

        # I'm an osu player lol
        "kernel.unprivileged_userns_clone" = "1";
        #"user.max_user_namespaces" = "1000";
      };
    };

    security = {
      forcePageTableIsolation = true;
      protectKernelImage = true;
    };

    nix.settings = {
      allowed-users = [ "@users" ];
    };

    environment = {
      memoryAllocator.provider = "graphene-hardened";
      systemPackages = with pkgs; [
        clamav
        lynis
      ];
    };

    services = {
      clamav.daemon.enable = true;
      clamav.updater.enable = true;
    };

    programs.firejail = {
      enable = true;
      wrappedBinaries = {
        zen = {
          executable = "${pkgs.zen-browser}/bin/zen";
          profile = "${pkgs.firejail}/etc/firejail/zen-browser.profile";
          extraArgs = [ "--blacklist=/etc/ld-nix.so.preload" ];
        };
        tor-browser = {
          executable = "${pkgs.tor-browser}/bin/tor-browser";
          profile = "${pkgs.firejail}/etc/firejail/torbrowser.profile";
          extraArgs = [ "--blacklist=/etc/ld-nix.so.preload" ];
        };
      };
    };
  };
}

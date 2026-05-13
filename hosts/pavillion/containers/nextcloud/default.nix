{ 
  system.stateVersion = "25.11";
  containers.nextcloud = {
    privateNetwork = true;
    hostAddress = "10.7.0.1";
    localAddress = "10.7.0.3";
    forwardPorts = [
      { containerPort = 80; hostPort = 8081; }
      { containerPort = 9050; hostPort = 9050; }
    ];
    bindMounts = {
      "nextcloud" = {
	hostPath = "/mnt/nextcloud";
	mountPoint = "/var/lib/nextcloud";
	isReadOnly = false;
      };
    };
    config = import ./config.nix;
  };
}

{ 
  system.stateVersion = "25.11";
  containers.nextcloud = {
    privateNetwork = true;
    hostAddress = "10.7.0.1";
    localAddress = "10.7.0.3";
    forwardPorts = [
      { containerPort = 80; hostPort = 9639; }
    ];
    config = import ./config.nix;
  };
}

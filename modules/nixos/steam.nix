{
  pkgs,
  ...
}:
{
  programs = {
    appimage = {
      enable = true;
      binfmt = true;
    };
    gamemode = {
      enable = true;
    };
    gamescope = {
      enable = true;
      capSysNice = true;
      env = {
        __VK_LAYER_NV_optimus = "NVIDIA_only";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        MANGOHUD = "1";
      };
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      dedicatedServer.openFirewall = true;
      protontricks.enable = true;
      extest.enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
      extraPackages = with pkgs; [
        gamescope
      ];
      gamescopeSession = {
        enable = true;
        args = [
          "--adaptive-sync"
          "--hdr-enabled"
          "--mangoapp"
          "--rt"
          "--steam"
        ];
        steamArgs = [
          "-pipewire-dmabuf"
          "-tenfoot"
        ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    steam-run
    mangohud
  ];
}

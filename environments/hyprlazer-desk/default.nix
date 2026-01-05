fuyupkgs:
{
  nixosModules.default = {
    imports = with fuyupkgs.nixosModules; [
      ./nixos
      stylix
    ];
  };
  homeModules.default = {
    imports = with fuyupkgs.homeModules; [
      ./home
      osu-resources
      stylix
    ];
  };
}


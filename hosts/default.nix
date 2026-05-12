fuyupkgs:
let
  inherit (fuyupkgs) withSystem;
  importHost = hostName: [
    ./${hostName}
    ./${hostName}/hardware-configuration.nix
    fuyupkgs.nixosModules.default
  ];
in
{
  # This one is an HP Pavillion (Gaming) Laptop btw
  pavillion = fuyupkgs.nixpkgs.lib.nixosSystem {
    pkgs = withSystem "x86_64-linux" fuyupkgs.nixpkgs;
    modules =
      (importHost "pavillion")
      ++ (with fuyupkgs; [
        withAllOverlays
        stylixModules.macchiato-cat
      ])
      ++ (with fuyupkgs.nixosModules; [
	stylix
        fonts
        locale-es-cr
        pipewire
        steam
        starship
	arrpc
	hyprpaper
	disable-bd-prochot
      ]);
  };
}


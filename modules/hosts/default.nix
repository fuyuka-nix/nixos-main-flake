fuyupkgs:
let
  inherit (fuyupkgs.lib) withSystem;
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
    specialArgs = { inherit fuyupkgs; };
    modules =
      (importHost "pavillion")
      ++ [
	{nixpkgs.overlays = with fuyupkgs.overlays; [
	  default
	  affinity-nix
	];}
      ]
      ++ (with fuyupkgs.nixosModules; [
	sops-nix
        fonts
        locale-es-cr
        pipewire
        steam
        starship
	arrpc
	disable-bd-prochot
      ]);
  };
}


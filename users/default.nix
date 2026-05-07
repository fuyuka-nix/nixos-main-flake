fuyupkgs:
let
  inherit (fuyupkgs) withSystem;
  homeConfiguration = fuyupkgs.home-manager.lib.homeManagerConfiguration;
  importUser = userName: [
    ./${userName}
    fuyupkgs.homeModules.default
    { home.username = "${userName}"; }
  ];
in
{
  "frozenfox" = homeConfiguration {
    pkgs = withSystem "x86_64-linux" fuyupkgs.nixpkgs;
    modules =
      (importUser "frozenfox")
      ++ (with fuyupkgs; [
        withAllOverlays
        stylixModules.macchiato-cat
      ])
      ++ (with fuyupkgs.homeModules; [
	stylix
        git
        xdg
        zsh
      ]);
  };
}


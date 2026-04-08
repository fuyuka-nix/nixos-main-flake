fuyupkgs:
(fuyupkgs.nixpkgs.lib.genAttrs [
  "hyprlazer-desk"
] (name: import ./${name} fuyupkgs))


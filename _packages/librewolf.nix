{
  appimageTools,
  fetchurl,
  speechd
}:
let
  pname = "librewolf";
  version = "152.0.1-2";

  src = fetchurl {
    url = "https://dl.librewolf.net/librewolf/${version}/librewolf-${version}-linux-x86_64-appimage.AppImage";
    hash = "sha256-/bw6JdrybBaBo0BWq9xJM9cStQOUm8NKnNn0nYgfaQc=";
  };
in
appimageTools.wrapType2 {
  inherit pname version src;
  extraPkgs = (_: [ speechd ]);
}

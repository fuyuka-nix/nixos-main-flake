{
  appimageTools,
  fetchurl
}:
let
  pname = "librewolf";
  version = "152.0.1-2";

  src = fetchurl {
    url = "https://dl.librewolf.net/librewolf/${version}/librewolf-${version}-linux-x86_64-appimage.AppImage";
    hash = "sha256-/bw6JdrybBaBo0BWq9xJM9cStQOUm8NKnNn0nYgfaQc=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: [ pkgs.speechd ];

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/net.librewolf.LibreWolf.desktop $out/share/applications/net.librewolf.LibreWolf.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/128x128/apps/librewolf.png \
      $out/share/icons/hicolor/128x128/apps/librewolf.png
  '';

  # specify src archive for nix-update
  passthru.src = src;
}

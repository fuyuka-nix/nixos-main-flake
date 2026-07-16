{
  appimageTools,
  fetchurl
}:
let
  pname = "librewolf";
  version = "152.0.6-1";

  src = fetchurl {
    url = "https://dl.librewolf.net/librewolf/${version}/librewolf-${version}-linux-x86_64-appimage.AppImage";
    hash = "sha256-KTd95zzCHj5T7rFaa3guApJqUfuW4i/13uYg4gUi5NY=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: with pkgs; [ speechd ffmpeg_4 ];

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/net.librewolf.LibreWolf.desktop $out/share/applications/net.librewolf.LibreWolf.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/128x128/apps/librewolf.png \
      $out/share/icons/hicolor/128x128/apps/librewolf.png
  '';

  # specify src archive for nix-update
  passthru.src = src;
}

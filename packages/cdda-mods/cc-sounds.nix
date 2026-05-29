{
  stdenv,
  fetchzip,
  lib,
  ...
}:

stdenv.mkDerivation {
  pname = "cc-sounds";

  src = fetchzip {
    url = "https://github.com/Fris0uman/CDDA-Soundpacks/releases/download/2025-11-15/CC-Sounds.zip";
    hash = "sha256-sha256:adf730636ae6b148bf0da8646e92a3ce44cc9f092a498a50f7299d8e5bfef2ee";
  };

  install-phase = ''
    mkdir -p $out
    cp -r ./* $out/
  ''

  meta = with lib; {
    description = "A soundpack for Clataclysm-dda made with CC-BY 4.0 only assets";
    homepage = "https://github.com/Fris0uman/CDDA-Soundpacks";
    license = licenses.cc-by-40;
    maintainers = with maintainers; [ Fuyuka-nix ];
    platforms = platforms.all;
  };
}

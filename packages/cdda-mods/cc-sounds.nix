{
  stdenv,
  fetchzip,
  lib,
  ...
}:

stdenv.mkDerivation rec {
  pname = "cc-sounds";
  version = "2025-11-15";

  src = fetchzip {
    url = "https://github.com/Fris0uman/CDDA-Soundpacks/releases/download/2025-11-15/CC-Sounds.zip";
    hash = "sha256-esMFyijsCWldF2iBCoBxy6CVe+Ld03z/on4MiIs5V+Y=";
  };

  installPhase = ''
    destdir="$out/share/cataclysm-dda/sound"
    mkdir -p "$destdir"
    cp -a ./ "$destdir/CC-Sounds"
  '';

  meta = with lib; {
    description = "A soundpack for Clataclysm-dda made with CC-BY 4.0 only assets";
    homepage = "https://github.com/Fris0uman/CDDA-Soundpacks";
    license = licenses.cc-by-sa-40;
    maintainers = with maintainers; [ Fuyuka-nix ];
    platforms = platforms.all;
  };
}

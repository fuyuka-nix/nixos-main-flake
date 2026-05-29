{
  stdenv,
  fetchFromGitHub,
  lib,
  ...
}:

stdenv.mkDerivation rec {
  pname = "cc-sounds";
  version = "2025-11-15";

  src = fetchFromGitHub {
    owner = "Fris0uman";
    repo = "CDDA-Soundpacks";
    tag = version;
    sha256 = "sha256-xDOybF6szJiyW3WygM2JhTmTwXUlmEFSBKv4k42ksXE=";
  };

  installPhase = ''
    mkdir -p $out
    cp -r sound/CC-Sounds/ $out
    cp LICENSE.txt $out/CC-Sounds
    cp CO.AG_authorisation.txt $out/CC-Sounds
  '';

  meta = with lib; {
    description = "A soundpack for Clataclysm-dda made with CC-BY 4.0 only assets";
    homepage = "https://github.com/Fris0uman/CDDA-Soundpacks";
    license = licenses.cc-by-40;
    maintainers = with maintainers; [ Fuyuka-nix ];
    platforms = platforms.all;
  };
}

{
  pkgs,
  lib,
  ...
}:

pkgs.stdenv.mkDerivation rec {
  pname = "osu-resources";
  version = "2026.615.0";

  src = pkgs.fetchFromGitHub {
    owner = "ppy";
    repo = "osu-resources";
    tag = version;
    hash = "sha256-V3MYeJm8Ypd8d2cVbKn4DcHgsDcJoH/7+RAWxhT3VFk=";
  };

  dontStrip = true;

  installPhase = ''
    runHook preInstall

    assetsOut="$out/share/${pname}"
    mkdir -p $assetsOut

    cp -r osu.Game.Resources/Textures $assetsOut/
    cp -r osu.Game.Resources/Samples $assetsOut/
    cp -r osu.Game.Resources/Tracks $assetsOut/
    cp -r osu.Game.Resources/Fonts $assetsOut/
    cp -r osu.Game.Resources/Localisation $assetsOut/
    cp -r osu.Game.Resources/Shaders $assetsOut/
    cp -r osu.Game.Resources/Skins $assetsOut/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Icons and Samples from osu!resources repo";
    homepage = "https://github.com/ppy/osu-resources";
    license = licenses.cc-by-nc-40;
    maintainers = with maintainers; [ fuyuka-nix ];
    platforms = platforms.all;
  };
}

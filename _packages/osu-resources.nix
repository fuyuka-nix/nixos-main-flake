{
  stdenv,
  fetchFromGitHub,
  lib
}:

stdenv.mkDerivation rec {
  pname = "osu-resources";
  version = "2026.710.0";

  src = fetchFromGitHub {
    owner = "ppy";
    repo = "osu-resources";
    tag = version;
    hash = "sha256-h1b5Isc278D3au8Y4CN130xgiw+AVBkhFzOaHdEyFic=";
  };

  installPhase = ''
    runHook preInstall

    assetsOut="$out/share/${pname}"
    mkdir -p $assetsOut

    ${lib.concatStringsSep "\n" (map (x: "cp ${x} $assetsOut/") [
      "README.md"
      "LICENCE.md"
      "crowdin.yml"
      "-r assets/medals"
    ])}

    ${lib.concatStringsSep "\n" (map (x: "cp -r osu.Game.Resources/${x} $assetsOut/") [
      "Textures"
      "Samples"
      "Tracks"
      "Fonts"
      "Localisation"
      "Shaders"
      "Skins"
      "ResourceAssembly.cs"
      "osu.Game.Resources.csproj"
    ])}

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

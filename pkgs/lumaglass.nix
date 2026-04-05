{
  lib,
  fetchurl,
  stdenv,
  _7zz,
}:

# This cannot be built from source due to the problematic nature of XCode - so
# this is what it's like when doves cry?

stdenv.mkDerivation rec {
  pname = "LumaGlass";
  version = "1.1.0";

  src = fetchurl {
    url = "https://github.com/likaia/MonitorControl/releases/download/v${version}/LumaGlass-${version}.dmg";
    hash = "sha256-Ld+Yg2AB/FrGLnPLaI/LWbNkf6NTN5L9N3Ic2cgjI2g=";
  };

  nativeBuildInputs = [ _7zz ];

  sourceRoot = "LumaGlass.app";

  installPhase = ''
    mkdir -p "$out/Applications/LumaGlass.app"
    cp -R . "$out/Applications/LumaGlass.app"
  '';

  meta = {
    description = "MacOS system extension to control brightness and volume of external displays with native OSD";
    longDescription = "Controls your external display brightness and volume and shows native OSD. Use menulet sliders or the keyboard, including native Apple keys!";
    homepage = "https://github.com/likaia/MonitorControl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      cbleslie
      cottand
    ];
    platforms = lib.platforms.darwin;
  };
}

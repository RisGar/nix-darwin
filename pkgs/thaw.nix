{
  lib,
  stdenvNoCC,
  unzip,
  fetchurl,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "thaw-bar";
  version = "1.1.99-beta.2";

  src = fetchurl {
    url = "https://github.com/stonerl/Thaw/releases/download/${finalAttrs.version}/Thaw_${finalAttrs.version}.zip";
    hash = "sha256-uTjrCR2cWHLEpnA2OS8aOx5a4OyFAe1aljaBjp8CcDA=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -r *.app "$out/Applications"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Powerful menu bar manager for macOS";
    homepage = "https://github.com/stonerl/Thaw";
    license = lib.licenses.gpl3;
    # maintainers = with lib.maintainers; [ FlameFlag ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})

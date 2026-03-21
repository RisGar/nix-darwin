{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "mole-mac";
  version = "1.30.0";

  src = fetchFromGitHub {
    owner = "tw93";
    repo = "Mole";
    rev = "V${finalAttrs.version}";
    hash = "sha256-uo/wPKObL5i6A0i/1hmOjXCzlJkkrFsmZHvLoHmM8Ro=";
  };

  vendorHash = "sha256-oepnMZcaTB9u3h6S0jcP4W0pqNkDDgETVqDdCL0jarM=";

  subPackages = [
    "cmd/analyze"
    "cmd/status"
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    libexec="$out/libexec"
    mkdir -p "$libexec"
    cp -r bin lib "$libexec/"

    install -m755 mole "$out/bin/mole"
    ln -s "$out/bin/mole" "$out/bin/mo"

    install -m755 "$out/bin/analyze" "$libexec/bin/analyze-go"
    install -m755 "$out/bin/status" "$libexec/bin/status-go"
    rm -f "$out/bin/analyze" "$out/bin/status"

    substituteInPlace "$out/bin/mole" \
      --replace-fail 'SCRIPT_DIR="$(cd "$(dirname "''${BASH_SOURCE[0]}")" && pwd)"' 'SCRIPT_DIR="$out/libexec"'
  '';

  doCheck = false;

  meta = {
    description = "Deep clean and optimize your Mac";
    homepage = "https://github.com/tw93/Mole";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    mainProgram = "mo";
  };
})

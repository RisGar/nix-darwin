{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "clippy-mac";
  version = "1.6.7";

  src = fetchFromGitHub {
    owner = "neilberkman";
    repo = "clippy";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IiBExKAnMWPWQbjM4E0E4kgjPaAurqNUFw509tLhZJI=";
  };

  vendorHash = "sha256-7do+KgoiIocS+mq2hsgv3NOd+TjMl2I9ew2Emx3/Bbg=";

  subPackages = [
    "cmd/clippy"
    "cmd/pasty"
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  doCheck = false;

  meta = {
    description = "Unified clipboard tool for macOS";
    homepage = "https://github.com/neilberkman/clippy";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    mainProgram = "clippy";
  };
})

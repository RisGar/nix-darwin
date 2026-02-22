{ config, lib, ... }:
{
  homebrew = {
    enable = true;

    onActivation = {
      cleanup = "zap";
    };

    taps = lib.attrNames config.nix-homebrew.taps;

    # `brew install`
    brews = [ ];

    casks = [
      "detexify"
      "devonthink"
      "ghostty" # not avaliable on darwin rn
      "macs-fan-control"
      "nordvpn"
      "onyx"
      "pearcleaner"
      "qlmarkdown"
      "qlvideo"
      "steam"
      "transmission-remote-gui"
      "zen"
      "zulip"
      "spotify" # breaks often on nix
      "helium-browser"
      "xquartz" # TODO: make ssh -X via nix work
      "affinity"
      "prusaslicer"
      "zoom"
      "yubico-authenticator"
      "visual-studio-code"
      "stirling-pdf" # https://github.com/NixOS/nixpkgs/pull/480680
      "tunnelblick"
      "hyperkey"
      "beeper"
    ];
  };
}

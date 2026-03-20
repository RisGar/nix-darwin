{ config, lib, ... }:
{
  homebrew = {
    enable = true;

    onActivation = {
      cleanup = "uninstall";
    };

    taps = lib.attrNames config.nix-homebrew.taps;

    # `brew install`
    brews = [ ];

    casks = [
      "affinity"
      "beeper"
      "boinc"
      "detexify"
      "devonthink"
      "ghostty" # not avaliable on darwin rn
      "helium-browser"
      "hyperkey"
      "macs-fan-control"
      "mole"
      "nordvpn"
      "onyx"
      "pearcleaner"
      "prusaslicer"
      "qlmarkdown"
      "qlvideo"
      "spotify" # breaks often on nix
      "steam"
      "stirling-pdf" # https://github.com/NixOS/nixpkgs/pull/480680
      "transmission-remote-gui"
      "tunnelblick"
      "visual-studio-code"
      "xquartz" # TODO: make ssh -X via nix work
      "yubico-authenticator"
      "zen"
      "zoom"
      "zulip"
    ];
  };
}

{ ... }:
{
  homebrew = {
    enable = true;

    onActivation = {
      cleanup = "zap";
    };

    # taps = [
    #   "sikarugir-app/sikarugir"
    # ];
    # taps = builtins.attrNames config.nix-homebrew.taps;

    # `brew install`
    # TODO: migrate to nix
    brews = [
      "dsda-doom"
      {
        name = "trash";
        link = true;
      }
    ];

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
      # "sikarugir-app/sikarugir/sikarugir"
      "steam"
      "transmission-remote-gui"
      "zen"
      "zulip"
      "spotify" # breaks often on nix
      # "prismlauncher"
      "helium-browser"
      "xquartz" # TODO: make ssh -X via nix work
      "affinity"
      "prusaslicer"
      "zoom"
      "yubico-authenticator"
    ];
  };
}

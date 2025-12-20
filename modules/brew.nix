{ ... }:
{
  homebrew = {
    enable = true;

    onActivation = {
      cleanup = "zap";
    };

    taps = [
      "nikolaeu/numi" # numi cli
      "sikarugir-app/sikarugir"
    ];
    # taps = builtins.attrNames config.nix-homebrew.taps;

    # `brew install`
    # TODO: migrate to nix
    brews = [
      "dsda-doom"
      "juliaup" # not avaliable on darwin
      {
        name = "trash";
        link = true;
      }
      "nikolaeu/numi/numi-cli"
    ];

    casks = [
      "detexify"
      "devonthink"
      "ghostty" # not avaliable on darwin rn
      "jordanbaird-ice@beta" # TODO: wait for 11.3 on unstable
      "macs-fan-control"
      "nordvpn"
      "onyx"
      "pearcleaner"
      "qlmarkdown"
      "qlvideo"
      "sikarugir-app/sikarugir/sikarugir"
      "steam"
      "transmission-remote-gui"
      "zen"
      "zulip"
      "spotify" # breaks often on nix
      "prismlauncher" # does not build on nix
      "helium-browser"
      "xquartz" # TODO: make ssh -X via nix work
      "affinity"
      "prusaslicer"
      "zoom"
      "ungoogled-chromium"
    ];
  };
}

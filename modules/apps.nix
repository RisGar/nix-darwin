{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    # bitwarden-cli # TODO: wait until https://github.com/NixOS/nixpkgs/issues/339576 is fixed
    # opam  TODO:
    # zulip-term # TODO: broken
    neovim # TODO: home manager
    airdrop-cli
    aria2
    babelfish
    beam.interpreters.erlang_28 # for gleescript
    luarocks
    bear
    doomrunner
    exercism
    ffmpeg
    grandperspective
    gum
    hyperfine
    iina
    imagemagick
    isabelle
    josm
    keepassxc
    mas
    moonlight-qt
    mosh
    nixd
    nixfmt
    numi
    obsidian
    ov
    pcre2
    pkg-config
    pkgconf
    pngpaste # For img-clip.nvim
    presenterm
    prismlauncher
    raycast
    semgrep
    shottr
    spotify # TODO: wait until not broken
    suspicious-package
    terminal-notifier
    tlrc # tldr rust client
    tokei
    transmission_4
    tree-sitter # for nvim-treesitter
    typst # TODO: devshell?
    vesktop
    virt-viewer
    vscode # TODO: home manager
    wakatime-cli
    wget # for mason
    xdg-ninja
    xh
    xz
    zotero

  ];

  homebrew = {
    enable = true;

    onActivation = {
      cleanup = "zap";
    };

    taps = [
      "homebrew/test-bot"
      "nikolaeu/numi" # numi cli
      "sikarugir-app/sikarugir"
    ];

    # `brew install`
    # TODO: migrate to nix
    brews = [
      "bitwarden-cli"
      # "libx11"
      # "openssl@3"
      "colima" # TODO
      "docker" # TODO:
      "docker-buildx"
      "docker-compose"
      "docker-credential-helper"
      "dsda-doom"
      # "pinentry"
      # "gnupg"
      "go"
      # "gstreamer"
      "juliaup"
      "p7zip"
      # "parallel"
      # "python@3.11"
      "rustup" # TODO: apps?
      "tmux" # TODO: home manager
      {
        name = "trash";
        link = true;
      }
      "nikolaeu/numi/numi-cli"
    ];

    casks = [
      "detexify"
      "devonthink"
      "ghostty"
      "git-credential-manager"
      "jordanbaird-ice@beta" # TODO: wait for 11.3
      # "macfuse"
      "macs-fan-control"
      "nordvpn"
      "onyx"
      "pearcleaner"
      "qlmarkdown"
      "qlvideo"
      "sikarugir-app/sikarugir/sikarugir"
      "steam"
      "transmission-remote-gui"
      "ungoogled-chromium"
      "zen"
      "zulip"
      # "xquartz"
    ];
  };
}

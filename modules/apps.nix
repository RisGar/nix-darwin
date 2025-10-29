{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    rustup
    # opam  TODO:
    # zulip-term # TODO: broken
    airdrop-cli
    docker
    docker-credential-helpers
    docker-compose
    docker-buildx
    aria2
    babelfish
    beam.interpreters.erlang_28 # for gleescript
    bear
    bitwarden-cli
    colima
    doomrunner
    exercism
    ffmpeg
    grandperspective
    gum
    hyperfine
    iina
    imagemagick
    isabelle
    llvmPackages_latest.clang
    llvmPackages_latest.clang-manpages
    luarocks
    man-pages
    man-pages-posix
    moonlight-qt
    mosh
    neovim # TODO: home manager
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
    raycast
    semgrep
    shottr
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
      # "docker" # TODO:
      # "docker-buildx"
      # "docker-compose"
      # "docker-credential-helper"
      "dsda-doom"
      "p7zip"
      "juliaup"
      # "rustup" # TODO: apps?
      # "tmux" # TODO: home manager
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
      "ungoogled-chromium" # not avaliable for darwin rn
      "zen"
      "zulip"
      "spotify" # breaks often on nix
      "prismlauncher" # does not build on nix
      "affinity-photo"
      "affinity-designer"
      "affinity-publisher"
    ];
  };
}

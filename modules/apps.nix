{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    # bitwarden-cli # TODO: wait until https://github.com/NixOS/nixpkgs/issues/339576 is fixed
    # doomrunner # TODO: broken
    isabelle # TODO: slowwww
    # opam  TODO:
    spotify # TODO: wait until not broken
    # zulip-term # TODO: broken
    aria2
    bat
    beam.interpreters.erlang_28 # for gleescript
    bear
    vesktop
    evil-helix
    exercism
    eza # TODO: home manager
    ffmpeg
    grandperspective
    gum
    hyperfine
    imagemagick
    keepassxc
    moonlight-qt
    mosh
    nixd
    nixfmt
    numi
    obsidian
    pcre2
    pkg-config
    pkgconf
    prismlauncher
    raycast
    semgrep
    shottr
    suspicious-package
    tlrc # tldr rust client
    tokei
    transmission_4
    tree-sitter # for nvim-treesitter
    typst # TODO: devshell?
    virt-viewer
    vscode # TODO: home manager
    wakatime-cli
    wget # for mason
    xdg-ninja
    xz
    zotero
    babelfish
    iina
    pngpaste # For img-clip.nvim
    terminal-notifier
    airdrop-cli

  ];

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };

    masApps = {
      "AdGuard for Safari" = 1440147259;
      "Apple Configurator" = 1037126344;
      "AusweisApp" = 948660805;
      "Bitwarden" = 1352778147;
      "ColorSlurp" = 1287239339;
      "Craft" = 1487937127;
      "Developer" = 640199958;
      "Dropover" = 1355679052;
      "eduVPN" = 1317704208;
      "Flow" = 1423210932;
      "Goodnotes" = 1444383602;
      "Keynote" = 409183694;
      "LocalSend" = 1661733229;
      "Mastonaut" = 1450757574;
      "MediaInfo" = 510620098;
      "Mela" = 1568924476;
      "Microsoft Excel" = 462058435;
      "Microsoft PowerPoint" = 462062816;
      "Microsoft Word" = 462054704;
      "Numbers" = 409203825;
      "Pages" = 409201541;
      "PastePal" = 1503446680;
      "PDFgear" = 6469021132;
      "Perplexity" = 6714467650;
      "Pixelmator Pro" = 1289583905;
      "Reeder" = 1529448980;
      "Rippple" = 1309894528;
      "Shazam" = 897118787;
      "Shukofukurou" = 1373973596;
      "Simple Comic" = 1497435571;
      "Step Two" = 1448916662;
      "TestFlight" = 899247664;
      "Things" = 904280696;
      "TUMCampusApp" = 1557123392;
      "Windows App" = 1295203466;
      "WireGuard" = 1451685025;
      "Xcode" = 497799835;
      "DeTeXt" = 1531906207;
    };

    taps = [
      "homebrew-zathura/zathura"
      "homebrew/test-bot"
      "nikitabobko/tap" # aerospace
      "nikolaeu/numi" # numi cli
      "noborus/tap" # ov
      "sikarugir-app/sikarugir"
    ];

    # `brew install`
    # TODO: migrate to nix
    brews = [
      "bitwarden-cli"
      "glib"
      "libx11"
      "aichat"
      "little-cms2"
      "jpeg-xl"
      "aom"
      "openssl@3"
      "libgit2"
      "node"
      "bob"
      "colima"
      "unixodbc"
      "llvm"
      "docker" # TODO:
      "docker-buildx"
      "docker-compose"
      "docker-credential-helper"
      "dsda-doom"
      "wxwidgets"
      # "exiftool"
      # "unbound"
      # "openjpeg"
      # "leptonica" # what is this used for?
      # "libraw"
      "gh"
      # "pinentry"
      # "gnupg"
      "go"
      # "gstreamer"
      "iamb"
      "jq"
      "juliaup"
      "jupyterlab"
      "just"
      "libadwaita"
      "libffi"
      "libvterm"
      "libxml2"
      "libxslt"
      "lrzip"
      "luajit"
      "luarocks"
      "mas"
      "p7zip"
      # "parallel"
      "presenterm"
      "python@3.11"
      "ripgrep"
      "ruby"
      "rustup"
      "tmux" # TODO: home manager
      {
        name = "trash";
        link = true;
      }
      "uutils-coreutils"
      # "watch"
      "websocat"
      "xh"
      "yadm"
      {
        name = "homebrew-zathura/zathura/zathura";
        args = [ "with-synctex" ];
      }
      "homebrew-zathura/zathura/zathura-cb"
      "homebrew-zathura/zathura/zathura-djvu"
      "homebrew-zathura/zathura/zathura-pdf-mupdf"
      "homebrew-zathura/zathura/zathura-ps"
      "nikolaeu/numi/numi-cli"
      "noborus/tap/ov"
    ];

    casks = [
      "aerospace" # TODO:
      "detexify"
      "devonthink"
      "ghostty" # TODO: home manager & wait for 1.2
      "git-credential-manager"
      "jordanbaird-ice@beta"
      "macfuse"
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

    # extraConfig = ''
    #   brew "mupdf", args: ["as-dependency"], postinstall: "brew reinstall zathura-pdf-mupdf"
    # '';
  };
}

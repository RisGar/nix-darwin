{ pkgs, ... }:
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    bat
    evil-helix
    hyperfine
    nixd
    nixfmt
    virt-viewer
    beam.interpreters.erlang_28 # for gleescript
    tokei
    aria2
    tlrc # tldr rust client
    bear # TODO: devshell?
    mosh
    wget # for mason
    # tectonic # for snacks.image
  ];

  fonts.packages = with pkgs; [
    maple-mono.NF
    maple-mono.NF-CN
  ];

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
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
      "Microsoft OneNote" = 784801555;
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
    };

    taps = [
      "charmbracelet/tap"
      "clojure/tools"
      "coursier/formulas" # scala
      "homebrew-zathura/zathura"
      "homebrew/bundle"
      "homebrew/cask"
      "homebrew/command-not-found"
      "homebrew/core"
      "homebrew/services"
      "homebrew/test-bot"
      # "jeffreywildman/virt-manager"
      "jesseduffield/lazygit"
      "nikitabobko/tap" # aerospace
      "nikolaeu/numi" # numi cli
      "noborus/tap" # ov
      "risgar/tap"
      "sikarugir-app/sikarugir"
      "unisonweb/unison"
      "vldmrkl/formulae" # airdrop-cli
    ];

    # `brew install`
    # TODO Feel free to add your favorite apps here.
    brews = [
      "glib"
      "libx11"
      "xz"
      "aichat"
      "little-cms2"
      "jpeg-xl"
      "aom"
      "openssl@3"
      "autoconf"
      "autoconf-archive"
      "automake"
      "libgit2"
      "node"
      "bitwarden-cli"
      "bob"
      "brew-cask-completion"
      "ccache"
      "chafa"
      "cmake"
      "colima"
      "unixodbc"
      "llvm"
      "pkgconf"
      "docker"
      "docker-buildx"
      "docker-compose"
      "docker-credential-helper"
      "dsda-doom"
      "dua-cli"
      "wxwidgets"
      "entr"
      "exercism"
      # "exiftool"
      "eza"
      "fastfetch"
      "fd"
      "unbound"
      # "openjpeg"
      # "leptonica"
      {
        name = "libarchive";
        link = true;
      }
      "ffmpeg"
      "ncurses"
      "libraw"
      "imagemagick"
      "folderify"
      "fop"
      "gcc"
      "gh"
      "ghostscript"
      "git"
      "git-delta"
      "git-lfs"
      "glow"
      "gnu-sed"
      "pinentry"
      "gnupg"
      "go"
      "gstreamer"
      "gum"
      "iamb"
      "jq"
      "juliaup"
      "jupyterlab"
      "just"
      "lazygit"
      "lf"
      "libadwaita"
      "libffi"
      "libvterm"
      "libxml2"
      "libxslt"
      "lrzip"
      "luajit"
      "luarocks"
      "mas"
      "mesa"
      "ninja"
      "mise"
      "opam"
      "openjdk@17"
      "openjdk@21"
      "p7zip"
      # "parallel"
      "pngpaste" # For img-clip.nvim
      "poppler"
      "presenterm"
      "python@3.11"
      "ripgrep"
      "ruby"
      "rustup"
      # "tree-sitter"
      "semgrep"
      "starship"
      "terminal-notifier"
      "tmux"
      {
        name = "trash";
        link = true;
      }
      "tree"
      "tree-sitter-cli"
      "trunk"
      "typst"
      "uutils-coreutils"
      "uv"
      "wakatime-cli"
      "watch"
      "weasyprint"
      "websocat"
      "xdg-ninja"
      "xh"
      "yadm"
      "yazi"
      "yt-dlp"
      "zig"
      "zlib"
      "charmbracelet/tap/mods"
      "clojure/tools/clojure"
      "coursier/formulas/coursier"
      {
        name = "homebrew-zathura/zathura/zathura";
        args = [ "with-synctex" ];
      }
      "homebrew-zathura/zathura/zathura-cb"
      "homebrew-zathura/zathura/zathura-djvu"
      "homebrew-zathura/zathura/zathura-pdf-mupdf"
      "homebrew-zathura/zathura/zathura-ps"
      # "jeffreywildman/virt-manager/virt-viewer"
      "nikolaeu/numi/numi-cli"
      "noborus/tap/ov"
      "unisonweb/unison/unison-language"
      {
        name = "vldmrkl/formulae/airdrop-cli";
        args = [ "HEAD" ];
      }
    ];

    # `brew install --cask`
    # TODO Feel free to add your favorite apps here.
    casks = [
      "aerospace"
      "amethyst"
      "balenaetcher"
      "devonthink"
      "discord"
      "ghostty"
      "git-credential-manager"
      "grandperspective"
      "iina"
      "isabelle"
      "jordanbaird-ice@beta"
      "keepassxc"
      "macfuse"
      "macs-fan-control"
      "mark-text"
      "moonlight"
      "nordvpn"
      "numi"
      "obsidian"
      "onyx"
      "pearcleaner"
      "prismlauncher"
      "qlmarkdown"
      "qlvideo"
      "qutebrowser"
      "raycast"
      "shottr"
      "sikarugir-app/sikarugir/sikarugir"
      "spotify"
      "steam"
      "suspicious-package"
      "termius"
      "transmission"
      "transmission-remote-gui"
      "ungoogled-chromium"
      "visual-studio-code"
      "whisky"
      "xquartz"
      "zed"
      "zen"
      "zotero"
      "zulip"
    ];
  };
}

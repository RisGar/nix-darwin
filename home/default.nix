{
  config,
  lib,
  pkgs,
  nvim-config,
  ...
}:
let
  ice-bar-beta = pkgs.ice-bar.overrideAttrs (oldAttrs: rec {
    version = "0.11.13-dev.2";
    src = pkgs.fetchurl {
      url = "https://github.com/jordanbaird/Ice/releases/download/${version}/Ice.zip";
      hash = "sha256-wbuqcfYev+Xuko95CvYJY6nyAjZNY/eNLGs+xRBc9KA=";
    };
  });
in
{
  imports = [
    ./config/aerospace
    ./config/eza
    ./config/fish
    ./config/git
    ./config/java
    ./config/lf
    ./config/nvim
    ./config/sketchybar
    ./config/ssh
    ./config/tmux
    ./config/zathura
    nvim-config.homeModule
  ];

  options = {
    vars = lib.mkOption { };
  };

  config = {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home.username = "rishab";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "25.11";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    # vars.system = "aarch64-darwin";

    nix.gc.automatic = true;

    vars.systemFlake = "/private/etc/nix-darwin";

    # old behaviour of linking instead of copying into Applications folder
    targets.darwin.linkApps.enable = true;
    targets.darwin.copyApps.enable = false;

    home.preferXdgDirectories = true;

    home.packages =
      with pkgs;
      [
        # pcre2 # TODO: remove?
        # zulip-term # TODO: broken
        airdrop-cli
        babelfish
        beam.interpreters.erlang_28 # for gleescript
        bear
        captive-browser
        clipboard-jh
        devcontainer
        doomrunner
        ffmpeg
        git-credential-manager
        github-copilot-cli
        grandperspective
        http-server
        iina
        imagemagick
        isabelle
        # julia-bin
        libqalculate
        llvmPackages_latest.clang
        llvmPackages_latest.clang-manpages
        localsend
        luarocks
        man-pages
        man-pages-posix
        mlpreview
        moonlight-qt
        mosh
        nixd
        nixfmt
        nixln-edit
        nodejs
        numi
        obsidian # TODO: home manager
        opencode
        ov
        papers
        pkgconf
        podman
        podman-compose
        presenterm
        prismlauncher
        rustup
        shottr
        suspicious-package
        terminal-notifier
        tlrc # tldr rust client
        tokei
        typst
        unison-ucm
        virt-viewer
        vscode
        wakatime-cli
        xdg-ninja
        xz
        zotero
      ]
      ++ [
        raycast
        ice-bar-beta
      ]
      ++
        # Fonts
        [
          maple-mono.NF
          maple-mono.NF-CN
          jost
          raleway
          source-sans
          source-sans-pro
          libertinus
          hanken-grotesk
          carlito
        ];

    fonts.fontconfig.enable = true;

    programs.btop = {
      enable = true;
      settings = {
        color_theme = "onedark"; # TODO: fix
        theme_background = false;
      };
    };

    programs.fzf = {
      enable = true;
      colors = {
        fg = "-1";
        "fg+" = "#ffffff";
        bg = "-1";
        "bg+" = "#4b5263";
        hl = "#c678dd";
        "hl+" = "#d858fe";
        info = "#98c379";
        prompt = "#61afef";
        pointer = "#be5046";
        marker = "#e5c07b";
        spinner = "#61afef";
        header = "#61afef";
      };
      defaultOptions = [
        "--cycle"
        "--layout=reverse"
      ];
      enableFishIntegration = false; # use fzf.fish
      # Also don't use tmux integration as `fzf-tmux` has been replaced by `--tmux`
    };

    programs.zoxide = {
      enable = true;
    };

    programs.uv = {
      enable = true;
    };

    programs.yt-dlp = {
      enable = true;
    };

    programs.bat = {
      enable = true;
      config = {
        theme = "TwoDark";
        pager = "${lib.getExe pkgs.ov} -F -H3";
      };
    };

    programs.fd = {
      enable = true;
    };

    xdg.configFile."fastfetch/ascii.txt".text = ''
                $1,1C1
              ,CC1
        $2,;11i:;11i11;,
      .tCGGGGGCCCGGGGt.
      $3fGCCCCCCCCCCCCi
      CCCCCCCCCCCCCC,
      $4tGCCCCCCCCCCCCf,
      ,CCCCCCCCCCCCCCG1
       $5,LGCCCGGGCCCCGf.
        .iLLLt11tLLf;
    '';
    programs.fastfetch = {
      enable = true;
      settings = builtins.fromJSON (builtins.readFile ./config/fastfetch/config.jsonc);
    };

    programs.starship = {
      enable = true;
      enableTransience = true;
      settings = builtins.fromTOML (builtins.readFile ./config/starship/starship.toml);
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    # programs.mise = {
    #   enable = true;
    #   globalConfig = {
    #     tools = {
    #       node = "lts";
    #     };
    #   };
    # };

    programs.gpg = {
      enable = true;
      homedir = "${config.xdg.dataHome}/gnupg";
    };

    programs.ripgrep = {
      enable = true;
    };

    programs.jq = {
      enable = true;
    };

    programs.opam = {
      enable = true;
    };

    programs.go = {
      enable = true;
      env = {
        GOPATH = "${config.xdg.dataHome}/go";
        GOBIN = "${config.xdg.dataHome}/go/bin";
      };

    };

    programs.aria2 = {
      enable = true;
    };

    programs.vesktop = {
      enable = true;
    };

    programs.man = {
      generateCaches = false;
    };

    xdg.configFile."captive-browser.toml".text = ''
      browser = ${
        lib.concatStringsSep " " [
          ''"""''
          ''open -n -W -a "Helium" --args''
          ''--user-data-dir=${config.xdg.dataHome}/chromium-captive''
          ''--proxy-server="socks5://$PROXY"''
          ''--proxy-bypass-list="<-loopback>"''
          ''--no-first-run''
          ''--new-window''
          ''--incognito''
          ''--no-default-browser-check''
          ''--no-crash-upload''
          ''--disable-extensions''
          ''--disable-sync''
          ''--disable-background-networking''
          ''--disable-client-side-phishing-detection''
          ''--disable-component-update''
          ''--disable-translate''
          ''--disable-web-resources''
          ''--safebrowsing-disable-auto-update''
          ''http://detectportal.firefox.com/canonical.html''
          ''"""''
        ]
      } 
      dhcp-dns = "ipconfig getoption en0 domain_name_server"
      socks5-addr = "localhost:11666"
    '';

    gtk = {
      enable = true;
      colorScheme = "dark";
    };

    xdg.configFile."ghostty/config".text = builtins.readFile ./config/ghostty/config;
  };
}

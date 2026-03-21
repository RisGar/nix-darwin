{
  agenix,
  config,
  direnv-instant,
  lib,
  nix-colors,
  nvim-config,
  ocrtool-mcp,
  pkgs,
  secrets,
  ...
}:
{
  imports = [
    agenix.homeManagerModules.default
    nix-colors.homeManagerModules.default
    nvim-config.homeModules.default
    direnv-instant.homeModules.direnv-instant

    ./config/aerospace
    ./config/captive-browser # TODO: replace with dnscypt proxy forwarding of firefox default captive portal getter site
    ./config/eza
    ./config/fastfetch
    ./config/fish
    ./config/fzf
    ./config/git
    ./config/java
    ./config/lf
    ./config/nvim
    ./config/ssh
    ./config/tmux
    ./config/zathura
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

    # old behaviour of linking instead of copying into Applications folder
    targets.darwin.linkApps.enable = true;
    targets.darwin.copyApps.enable = false;

    age = {
      inherit secrets;
      identityPaths = [ (config.home.homeDirectory + "/.ssh/agenix") ];
    };

    colorScheme = nix-colors.colorSchemes.onedark;

    vars.systemFlake = "/private/etc/nix-darwin";

    home.packages =
      with pkgs;
      [
        mole-mac
        cinny-desktop
        # pcre2 # TODO: remove?
        agenix
        airdrop-cli
        babelfish
        beam.interpreters.erlang_28 # for gleescript
        bear
        captive-browser
        clipboard-jh
        csvlens
        doomrunner
        ffmpeg
        git-credential-manager
        github-copilot-cli
        grandperspective
        http-server
        iina
        imagemagick
        isabelle
        julia-bin
        libqalculate
        llvmPackages_latest.clang
        llvmPackages_latest.clang-manpages
        localsend
        logseq
        luarocks
        man-pages
        man-pages-posix
        mlpreview
        moonlight-qt
        mosh
        nix-tree
        nixd
        nixfmt
        nixos-rebuild
        numi
        obsidian # TODO: home manager
        ov
        papers
        pkgconf
        podman
        podman-compose
        presenterm
        prismlauncher
        raycast
        rustup
        shottr
        stirling-pdf
        suspicious-package
        terminal-notifier
        thaw
        tlrc # tldr rust client
        tokei
        typst
        unison-ucm
        virt-viewer
        wakatime-cli
        whatsapp-for-mac
        xdg-ninja
        xz
        zotero
        zulip-term # TODO: broken
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

    xdg.configFile."btop/themes/onedark.theme".text =
      builtins.readFile "${config.programs.btop.package.outPath}/share/btop/themes/onedark.theme"; # fix themes not working with home-manager symlink
    programs.btop = {
      enable = true;
      settings = {
        color_theme = "onedark"; # TODO: fix
        theme_background = false;
        vim_keys = true;
      };
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
        pager = "${lib.getExe pkgs.ov} -F -H4";
      };
    };

    programs.fd = {
      enable = true;
    };

    programs.starship = {
      enable = true;
      enableTransience = true;
      settings = fromTOML (builtins.readFile ./config/starship/starship.toml);
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    # TODO:
    # programs.direnv-instant = {
    #   enable = true;
    # };

    programs.gpg = {
      enable = true;
    };

    programs.ripgrep = {
      enable = true;
    };

    programs.jq = {
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

    gtk = {
      enable = true;
      colorScheme = "dark";
    };

    xdg.configFile."ghostty/config".text = builtins.readFile ./config/ghostty/config;

    programs.mcp = {
      enable = true;
      servers = {
        context7 = {
          url = "https://mcp.context7.com/mcp";
          headers = {
            CONTEXT7_API_KEY = "{env:CONTEXT7_API_KEY}";
          };
        };
        tavily = {
          url = "https://mcp.tavily.com/mcp/?tavilyApiKey={env:TAVILY_API_KEY}";
        };
        ocrtool = {
          command = lib.getExe ocrtool-mcp.packages.${pkgs.stdenv.hostPlatform.system}.default;
        };
        things = {
          command = lib.getExe' config.programs.uv.package "uvx";
          args = [ "things-mcp" ];
        };

      };
    };

    programs.opencode = {
      enable = true;
      enableMcpIntegration = true;
      settings = builtins.fromJSON <| builtins.readFile ./config/opencode/opencode.json;
    };

    services.ollama = {
      enable = true;
    };

    programs.nh = {
      enable = true;
      clean = {
        enable = true;
      };
    };
  };
}

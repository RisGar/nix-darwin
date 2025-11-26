{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./config/aerospace
    ./config/eza
    ./config/fish
    ./config/java
    ./config/git
    ./config/lf
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
    home.stateVersion = "25.05";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    nix.gc.automatic = true;

    vars.systemFlake = "/etc/nix-darwin";

    home.packages =
      with pkgs;
      [
        # zulip-term # TODO: broken
        git-credential-manager
        clipboard-jh
        airdrop-cli
        babelfish
        beam.interpreters.erlang_28 # for gleescript
        bear
        bitwarden-cli
        colima
        devcontainer
        docker
        docker-buildx
        docker-compose
        docker-credential-helpers
        doomrunner
        ffmpeg
        github-copilot-cli
        grandperspective
        http-server
        iina
        imagemagick
        isabelle
        libqalculate
        llvmPackages_latest.clang
        llvmPackages_latest.clang-manpages
        luarocks
        man-pages
        man-pages-posix
        mermaid-cli # dependency of snacks.image
        mlpreview
        moonlight-qt
        mosh
        neovim # TODO: home manager
        nixd
        nixfmt
        nodejs
        numi
        obsidian # TODO: home manager
        ov
        pcre2 # TODO: remove?
        pkgconf
        pngpaste # For img-clip.nvim
        presenterm
        raycast
        rustup
        shottr
        suspicious-package
        terminal-notifier
        tlrc # tldr rust client
        tokei
        transmission_4
        tree-sitter # for nvim-treesitter
        typst
        unison-ucm
        virt-viewer
        vscode # TODO: home manager?
        wakatime-cli
        wget # required by mason
        xdg-ninja
        xh
        xz
        zotero
        localsend
      ]
      ++ [
        # LSPs
        astro-language-server
        basedpyright
        bash-language-server
        biome
        docker-language-server
        fish-lsp
        gleam
        jdt-language-server
        lua-language-server
        markdownlint-cli2
        marksman
        prettierd
        ruff
        stylua
        svelte-language-server
        tailwindcss-language-server
        taplo
        texlab
        tinymist
        vscode-langservers-extracted
        vtsls
        yaml-language-server
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

    xdg.configFile."nvim" = {
      source = ./config/nvim;
      recursive = true;
    };
  };
}

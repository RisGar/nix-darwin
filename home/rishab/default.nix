{
  config,
  lib,
  pkgs,
  nvim-config,
  nix-colors,
  agenix,
  nixln-edit,
  mlpreview,
  ...
}:
let
  ice-bar-beta = pkgs.ice-bar.overrideAttrs (oldAttrs: {
    version = "0.11.13-dev.2h-unofficial";
    src = pkgs.fetchurl {
      url = "https://github.com/user-attachments/files/24932833/Ice.zip";
      hash = "sha256-bfY5AOP0Anwf5wu0pVzj+WxzuJditvfuMRW+DmlZZOc=";
    };
  });
in
{
  imports = [
    nvim-config.homeModule
    nix-colors.homeManagerModules.default

    ./config/aerospace
    ./config/captive-browser
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

    # vars.system = "aarch64-darwin";

    nix.gc.automatic = true;

    vars.systemFlake = "/private/etc/nix-darwin";

    # old behaviour of linking instead of copying into Applications folder
    targets.darwin.linkApps.enable = true;
    targets.darwin.copyApps.enable = false;

    colorScheme = nix-colors.colorSchemes.onedark;

    vars.mlpreview = mlpreview.packages.${pkgs.stdenv.hostPlatform.system}.default;

    home.packages =
      with pkgs;
      [
        # pcre2 # TODO: remove?
        # zulip-term # TODO: broken
        nixos-rebuild
        agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
        nixln-edit.packages.${pkgs.stdenv.hostPlatform.system}.default
        config.vars.mlpreview
        devpod
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
        # isabelle
        # julia-bin
        libqalculate
        llvmPackages_latest.clang
        llvmPackages_latest.clang-manpages
        localsend
        luarocks
        man-pages
        man-pages-posix
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
        wakatime-cli
        xdg-ninja
        xz
        zotero
        stirling-pdf
        (raycast.overrideAttrs (oldAttrs: {
          version = "1.104.3";
          src = pkgs.fetchurl {
            url = "https://releases.raycast.com/releases/${version}/download?build=arm";
            hash = "sha256-bfY5AOP0Anwf5wu0pVzj+WxzuJditvfuMRW+DmlZZOc=";
          };
        }))
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
        pager = "${lib.getExe pkgs.ov} -F -H3";
      };
    };

    programs.fd = {
      enable = true;
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

    gtk = {
      enable = true;
      colorScheme = "dark";
    };

    xdg.configFile."ghostty/config".text = builtins.readFile ./config/ghostty/config;
  };
}

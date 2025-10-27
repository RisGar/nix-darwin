{
  config,
  lib,
  pkgs,
  ...
}:
{
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

  home.packages =
    with pkgs;
    [
      unison-ucm
      mlpreview
      delta # dependency of git config
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

  imports = [
    ./config/git
    ./config/lf
    ./config/fish
    ./config/aerospace
    ./config/tmux
  ];

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "onedark"; # TODO: fix
      theme_background = false;
    };
  };

  programs.sesh = {
    enable = true;
    enableTmuxIntegration = false; # TODO: custom prompt with nerd font instead of emojis via overlay
    settings = {
      default_session = {
        preview_command = "eza -aF --color=always --git --group-directories-first --icons {}";
        startup_command = "nvim -c ':lua Snacks.picker.files(opts)'";
      };

      session = [
        {
          name = "Notes 󰎞";
          path = "~/Documents/Notes";
        }
        {
          name = "Nix 󱄅";
          path = "/etc/nix-darwin";
        }
      ];
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

  xdg.configFile."lazygit/config.yml".source = ./config/lazygit/config.yml;
  programs.lazygit = {
    enable = true;
    # don't use settings as nix cannot natively read yaml files
  };

  programs.java = {
    enable = true;
    package = pkgs.jdk21;
  };

  programs.zathura = {
    enable = true;
    mappings = {
      "r" = "reload";
      "R" = "rotate";
      "p" = "print";
      "i" = "recolor";
      "f" = "toggle_fullscreen";
      "[fullscreen]f" = "toggle_fullscreen";
    };
    extraConfig = builtins.readFile ./config/zathura/zathurarc;
    package = pkgs.zathura.override {
      useMupdf = true;
    };
  };

  programs.ripgrep = {
    enable = true;
  };

  programs.jq = {
    enable = true;
  };

  programs.eza = {
    enable = true;
    colors = "always";
    icons = "always";
    git = true;
    extraOptions = [
      "--classify=always"
      "--group-directories-first"
    ];
  };

  programs.gh = {
    enable = true;
    extensions = [ pkgs.gh-markdown-preview ];
    settings = {
      aliases = {
        ".gitignore" = "!gh api -X GET /gitignore/templates/\"$1\" --jq \".source\"";
      };
    };
  };
}

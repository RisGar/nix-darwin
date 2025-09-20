{
  pkgs,
  mlpreview,
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

  xdg.enable = true;

  home.packages = [
    mlpreview.packages.${pkgs.system}.default
    pkgs.delta # dependency of git config
  ];

  home.shellAliases = {
    cp = "cp -i";
    mv = "mv -i";
    rm = "rm -i";

    cd = "z";
    ".." = "z ..";

    nixrepl = "nix repl --expr '{inherit (import <nixpkgss> {}) pkgs lib;}'";
  };

  xdg.configFile."fish/themes/One Dark.theme".source = ./config/fish/one_dark.theme;
  programs.fish = {
    enable = true;
    shellInit = builtins.readFile ./config/fish/config.fish;
    plugins = [
      {
        name = "fzf.fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "autopair.fish";
        src = pkgs.fishPlugins.autopair-fish.src;
      }
      {
        name = "puffer-fish"; # Expand consecutive dots
        src = pkgs.fishPlugins.puffer.src;
      }
      {
        name = "sponge"; # Clean failed commands from history
        src = pkgs.fishPlugins.sponge.src;
      }
      {
        name = "fish-abbreviation-tips";
        src = pkgs.fetchFromGitHub {
          owner = "gazorby";
          repo = "fish-abbreviation-tips";
          rev = "v0.7.0";
          hash = "sha256-F1t81VliD+v6WEWqj1c1ehFBXzqLyumx5vV46s/FZRU=";
        };
      }
    ];
  };

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
      pager = "ov -F -H3";
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

  programs.lf = {
    enable = true;
    previewer.source = mlpreview.packages.${pkgs.system}.default + /bin/mlpreview;
    previewer.keybinding = "i"; # TODO: override less with pager in overlay
    extraConfig = builtins.readFile ./config/lf/lfrc;
    cmdKeybindings = {
      r = "rename";
      D = "delete";
      x = "cut";
      y = "copy";
      d = "";
      R = "reload";
      p = "paste";
    };
    commands = {
      trash = "%trash -F $fx";
      copy-path = "$printf '%s' \"$fx\" | pbcopy";
      q = "quit";
      make-exec = "%chmod 755 $f && lf -remote \"send $id reload\"";
      make-normal = "%chmod 644 $f && lf -remote \"send $id reload\"";
    };
    keybindings = {
      "<c-d>" = "trash";
      Y = "copy-path";
      "<c-e>" = "make-exec";
      "<c-n>" = "make-normal";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.mise = {
    enable = true;
    globalConfig = {
      tools = {
        node = "lts";
      };
    };
  };

  programs.git = {
    enable = true;

    userName = "Rishab Garg";
    userEmail = "me@rishab-garg.me";

    signing = {
      key = "7EC2233FD90AF4F1";
      signByDefault = true;
      format = "openpgp";
    };

    lfs.enable = true;

    extraConfig = {
      core = {
        editor = "nvim";
        pager = "${pkgs.delta}/bin/delta --pager='ov -F'";
      };

      interactive = {
        diffFilter = "${pkgs.delta}/bin/delta --color-only";
      };

      pager = {
        show = "${pkgs.delta}/bin/delta --pager='ov -F --header 3'";
        diff = "${pkgs.delta}/bin/delta --features ov-diff";
        log = "${pkgs.delta}/bin/delta --features ov-log";
      };

      delta = {
        navigate = true;
        dark = true;
        "ov-diff" = {
          pager = "ov -F --section-delimiter '^(commit|added:|removed:|renamed:|Δ)' --section-header --pattern '•'";
        };
        "ov-log" = {
          pager = "ov -F --section-delimiter '^commit' --section-header-num 3";
        };
      };

      merge = {
        conflictstyle = "zdiff3";
      };

      filter.lfs = {
        clean = "git-lfs clean -- %f";
        smudge = "git-lfs smudge -- %f";
        process = "git-lfs filter-process";
        required = true;
      };

      pull = {
        rebase = false;
      };

      init = {
        defaultBranch = "master";
      };

      credential = {
        helper = "/usr/local/share/gcm-core/git-credential-manager";
        "https://artemis.cit.tum.de" = {
          provider = "generic";
        };
        "https://artemis.tum.de" = {
          provider = "generic";
        };
        "https://git.fs.tum.de" = {
          provider = "generic";
        };
      };
    };
  };

  xdg.configFile."lazygit/config.yml".src = ./config/lazygit/config.yml;
  programs.lazygit = {
    enable = true;
    # don't use settings as nix cannot natively read yaml files
  };

}

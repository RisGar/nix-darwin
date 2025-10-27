{
  pkgs,
  lib,
  config,
  ...
}:
let
  autoStartTmux = true;
in
{
  xdg.enable = true;

  home.shellAliases = {
    cp = "cp -i";
    mv = "mv -i";
    rm = "rm -i";

    cd = "z";
    ".." = "z ..";

    nixrepl = "nix repl --expr '{inherit (import <nixpkgs> {}) pkgs lib;}'";

    trash = "trash -F";
    spotify-dlp = "yt-dlp --config-locations ~/.config/yt-dlp/config-spotify";

  };

  home.sessionPath = [
    "$(${config.home.sessionVariables.HOMEBREW_PREFIX}/bin/brew --prefix rustup)/bin"
    "${config.home.sessionVariables.HOMEBREW_PREFIX}/opt/llvm/bin"
    "$(${config.home.sessionVariables.HOMEBREW_PREFIX}/bin/brew --prefix python)/libexec/bin"
    "$GOPATH/bin"
    "$XDG_BIN_HOME"
    "$CARGO_HOME/bin"
    "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
    "${config.home.sessionVariables.HOMEBREW_PREFIX}/bin"
    "${config.home.sessionVariables.HOMEBREW_PREFIX}/sbin"
    "$CABAL_DIR/bin"
    "$PNPM_HOME"
    "$GEM_HOME/bin"
    "${config.xdg.dataHome}/bob/nvim-bin"
    "$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
    "${config.home.sessionVariables.HOMEBREW_PREFIX}/opt/ruby/bin"
    "/Library/TeX/texbin"
  ];

  home.sessionVariables = {
    XDG_BIN_HOME = "$HOME/.local/bin";

    LANG = "en_GB.UTF-8";

    # Use neovim as default editor and manpager
    EDITOR = "nvim -e";
    VISUAL = "nvim";
    MANPAGER = "nvim +Man!";

    PAGER = "ov";

    MACOSX_DEPLOYMENT_TARGET = 15;

    # Homebrew config
    HOMEBREW_PREFIX = "/opt/homebrew";
    HOMEBREW_CELLAR = "${config.home.sessionVariables.HOMEBREW_PREFIX}/Cellar";
    HOMEBREW_REPOSITORY = "${config.home.sessionVariables.HOMEBREW_PREFIX}";
    HOMEBREW_BAT = 1;

    # Force programs to use XDG dirs
    OPAMROOT = "${config.xdg.dataHome}/opam";
    NODE_REPL_HISTORY = "${config.xdg.dataHome}/node_repl_history";
    GOPATH = "${config.xdg.dataHome}/go";
    GHCUP_USE_XDG_DIRS = 1;
    STACK_XDG = 1;
    KAGGLE_CONFIG_DIR = "${config.xdg.configHome}/kaggle";
    RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
    CARGO_HOME = "${config.xdg.dataHome}/cargo";
    WAKATIME_HOME = "${config.xdg.configHome}/wakatime";
    UNISON = "${config.xdg.dataHome}/unison";
    JULIA_DEPOT_PATH = "${config.xdg.dataHome}/julia:$JULIA_DEPOT_PATH";
    DOCKER_CONFIG = "${config.xdg.configHome}/docker";

    ## C(++) compilers
    CC = lib.getExe pkgs.llvmPackages_latest.clang;
    CXX = lib.getExe pkgs.llvmPackages_latest.clang + "++";
  };

  home.sessionSearchVariables = {
    MANPATH = [
      "${config.home.sessionVariables.HOMEBREW_PREFIX}/share/man"
      "${config.home.sessionVariables.HOMEBREW_PREFIX}/opt/libarchive/share/man"
    ];
    INFOPATH = [ "${config.home.sessionVariables.HOMEBREW_PREFIX}/share/info" ];
    fish_complete_path = [
      "${config.home.sessionVariables.HOMEBREW_PREFIX}/share/fish/vendor_completions.d"
      "${config.home.sessionVariables.HOMEBREW_PREFIX}/share/fish/completions"
    ];
    __fish_vendor_confdirs = [
      "${config.home.sessionVariables.HOMEBREW_PREFIX}/share/fish/vendor_conf.d"
    ];

  };

  xdg.configFile."fish/themes/One Dark.theme".source = ./one_dark.theme;
  programs.fish = {
    enable = true;
    shellInit = ''
      # OCaml
      source /Users/rishab/.local/share/opam/opam-init/init.fish >/dev/null 2>/dev/null; or true

      # fzf
      set fzf_preview_dir_cmd eza --all --color=always
      set fzf_fd_opts --hidden --exclude=.git

      fzf_configure_bindings --directory=\cf

      # Vi mode
      function fish_user_key_bindings
          fish_vi_key_bindings insert
      end

      set fish_cursor_default block blink
      set fish_cursor_insert line blink
      set fish_cursor_replace_one underscore blink
      set fish_cursor_replace underscore blink
      set fish_cursor_external line blink

      # bind -M visual -m default y "fish_clipboard_copy; commandline -f end-selection repaint-mode"
      # bind p forward-char "commandline -i ( pbpaste; echo )[1]" # TODO

      # Theme
      fish_config theme choose "One Dark"

      # Fastfetch
      function fish_greeting
          fastfetch
      end

      # Starship transient prompts
      function starship_transient_prompt_func
          starship module character
      end

      function starship_transient_rprompt_func
          starship module time
      end
    '';
    shellInitLast = lib.optionalString autoStartTmux ''
      if status is-interactive
      and not set -q TMUX
        exec tmux new -As0
      end
    '';
    functions = {
      # Adapted from https://gist.github.com/jsongerber/7dfd9f2d22ae060b98e15c5590c4828d
      oil = {
        description = "Opens pre-configured ssh hosts with oil";
        body = ''
          set host (grep 'Host\>' ~/.ssh/config | sed 's/^Host //' | grep -v '\*' | gum filter --limit 1 --no-sort --fuzzy --placeholder 'Pick an ssh host' --prompt="󰣀 ")
          if test -z "$host"
              return 0
          end
          set user (ssh -G "$host" | grep '^user\>' | sed 's/^user //')
          nvim oil-ssh://$user@$host/
        '';
      };

      git_clone_and_cd = {
        description = "Git clones a repo and cds into it";
        body = ''
          git clone $argv[1]
          if test $status -eq 0
            set repo (basename $argv[1] .git)
            cd $repo
          end
        '';
      };

      lf = {
        wraps = "lf";
        description = "lf - Terminal file manager (changing directory on exit)";
        body = "cd \"$(command lf -print-last-dir $argv)\"";
      };

      fd = {
        wraps = "fd";
        description = "fd with bat";
        body = "command fd $argv -X bat";
      };

      reload = {
        description = "Reloads nix-darwin";
        body = ''
          gltangle ~/.config/ghostty/README.md
          ghostty +validate-config

          sudo -i darwin-rebuild switch -I /etc/nix-darwin/flake.nix
          source ~/.config/fish/config.fish
        '';
      };
    };
    shellAbbrs = {
      gc = "git_clone_and_cd";
    };
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
}

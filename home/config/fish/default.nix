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
    shellInit = builtins.readFile ./config.fish;
    shellInitLast = lib.optionalString autoStartTmux ''
      if status is-interactive
      and not set -q TMUX
        exec tmux new -As0
      end
    '';
    functions = {
      # Adapted from https://gist.github.com/jsongerber/7dfd9f2d22ae060b98e15c5590c4828d
      oil = ''
        set host (grep 'Host\>' ~/.ssh/config | sed 's/^Host //' | grep -v '\*' | gum filter --limit 1 --no-sort --fuzzy --placeholder 'Pick an ssh host' --prompt="󰣀 ")
        if test -z "$host"
            return 0
        end
        set user (ssh -G "$host" | grep '^user\>' | sed 's/^user //')
        nvim oil-ssh://$user@$host/
      '';

      git_clone_and_cd = ''
        git clone $argv[1]
        if test $status -eq 0
          set repo (basename $argv[1] .git)
          cd $repo
        end
      '';
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

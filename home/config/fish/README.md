---
tangle: /private/etc/nix-darwin/home/config/fish/config.fish
---

# Fish config

- Configuration is done inside of `README.md` which is tangled to `config.fish`
- Plugins are added via `fish_plugins`
- The other files and directories are managed by fish itself, fisher, Homebrew, ...

## Sources

- [DistroTube's fish config](https://gitlab.com/dwt1/dotfiles/-/blob/master/.config/fish/config.fish)

## Dependencies

- [fish-shell/fish-shell](https://github.com/fish-shell/fish-shell)
- [Homebrew](https://brew.sh/)
- [A Nerd Font](https://www.nerdfonts.com/)

## XDG Config

Uses the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) to organise dotfiles.

```fish
set -gx XDG_BIN_HOME "$HOME/.local/bin"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_STATE_HOME "$HOME/.local/state"
```

## Variables

```fish
set -gx LC_ALL "en_GB.UTF-8"

set -gx HOMEBREW_PREFIX "/opt/homebrew"
set -gx HOMEBREW_CELLAR "$HOMEBREW_PREFIX/Cellar"
set -gx HOMEBREW_REPOSITORY "$HOMEBREW_PREFIX"
set -gx MANPATH '' $MANPATH
set -gx INFOPATH "/opt/homebrew/share/info" $INFOPATH

set -gx PNPM_HOME "$XDG_DATA_HOME/pnpm"

set -gx PAGER "ov"
set -gx GIT_PAGER "delta"

set -gx CC "$HOMEBREW_PREFIX/opt/llvm/bin/clang"
set -gx CXX "$HOMEBREW_PREFIX/opt/llvm/bin/clang++"

set -gx GEM_HOME "$XDG_DATA_HOME/gem"
set -gx GEM_SPEC_CACHE "$XDG_CACHE_HOME"/gem
set -gx OPAMROOT "$XDG_DATA_HOME/opam"
set -gx NODE_REPL_HISTORY "$XDG_DATA_HOME/node_repl_history"
set -gx LESSHISTFILE "$XDG_CACHE_HOME/less/history"
set -gx GOPATH "$XDG_DATA_HOME/go"
set -gx CABAL_CONFIG "$XDG_CONFIG_HOME/cabal/config"
set -gx CABAL_DIR "$XDG_DATA_HOME/cabal"
set -gx GHCUP_USE_XDG_DIRS true
set -gx STACK_XDG true
set -gx KAGGLE_CONFIG_DIR "$XDG_CONFIG_HOME/kaggle"
set -gx GNUPGHOME "$XDG_DATA_HOME/gnupg"
set -gx RUSTUP_HOME "$XDG_DATA_HOME/rustup"
set -gx CARGO_HOME "$XDG_DATA_HOME/cargo"
set -gx WAKATIME_HOME "$XDG_CONFIG_HOME/wakatime"
set -gx TLDR_CACHE_DIR "$XDG_CACHE_HOME/tldr"
set -gx HAXE_STD_PATH "$HOMEBREW_PREFIX/lib/haxe/std"
set -gx EZA_CONFIG_DIR "$XDG_CONFIG_HOME/eza"
set -gx UNISON "$XDG_DATA_HOME"/unison
set -gx JULIA_DEPOT_PATH "$XDG_DATA_HOME/julia:$JULIA_DEPOT_PATH"
set -gx DOCKER_CONFIG "$XDG_CONFIG_HOME/docker"
```

## Path

```fish
fish_add_path $($HOMEBREW_PREFIX/bin/brew --prefix rustup)/bin "$HOMEBREW_PREFIX/opt/llvm/bin" \
$($HOMEBREW_PREFIX/bin/brew --prefix python)/libexec/bin "$GOPATH/bin" "$XDG_BIN_HOME" "$CARGO_HOME/bin" \
"/Applications/Visual Studio Code.app/Contents/Resources/app/bin" "$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin" \
"$CABAL_DIR/bin" "$PNPM_HOME" "$GEM_HOME/bin" "$XDG_DATA_HOME/bob/nvim-bin" \
"$HOME/Library/Application Support/Coursier/bin" "$HOME/Library/Application Support/JetBrains/Toolbox/scripts" \
"$HOMEBREW_PREFIX/opt/ruby/bin" "/Library/TeX/texbin"

set -gx MANPATH "/opt/homebrew/opt/libarchive/share/man" $MANPATH

set -p fish_complete_path "$HOMEBREW_PREFIX/share/fish/vendor_completions.d" "$HOMEBREW_PREFIX/share/fish/completions"
set -p __fish_vendor_confdirs "$HOMEBREW_PREFIX/share/fish/vendor_conf.d"
```

## Language hooks

Hooks to setup support for language ecosystems

```fish
source /Users/rishab/.local/share/opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5)"
```

## Aliases

Aliases and abbreviations to shorten or modify often-used commands.

```fish

alias cp "cp -i"
alias mv 'mv -i'
alias rm 'rm -i'

alias trash="trash -F"
alias spotify-dlp="yt-dlp --config-locations ~/.config/yt-dlp/config-spotify"
alias iamb="iamb -C $XDG_CONFIG_HOME"

function git_clone_and_cd
    git clone $argv[1]
    if test $status -eq 0
        set repo (basename $argv[1] .git)
        cd $repo
    end
end
abbr --add gc git_clone_and_cd
```

### Config tangling

- [RisGar/gltangle](https://github.com/RisGar/crtangle): tangles this (and other) Markdown file(s) to their respective config files.

```fish
function reload
    gltangle ~/.config/ghostty/README.md
    ghostty +validate-config

    gltangle /etc/nix-darwin/home/config/fish/README.md
    sudo -i darwin-rebuild switch -I /etc/nix-darwin/flake.nix
end
```

## Software

### neovim

- [neovim/neovim](https://github.com/neovim/neovim): [see my config](../nvim/README.md)
- Use neovim as default editor and manpager

```fish
set -gx EDITOR nvim -e
set -gx VISUAL nvim
set -gx MANPAGER "nvim +Man!"
```

### bat

- [sharkdp/bat](https://github.com/sharkdp/bat): `cat` replacement

```fish
set -gx BAT_THEME "OneHalfDark"

set -gx HOMEBREW_BAT true

# work with fd
function fd
    command fd $argv -X bat
end

# work with ov pager
set -gx BAT_PAGER "ov -F -H3"
alias bat "bat --wrap=never"
```

### zoxide

- [ajeetdsouza/zoxide](https://github.com/ajeetdsouza/zoxide): `cd` replacement

```fish
alias cd "z"
alias .. 'z ..'
```

### eza

- [eza-community/eza](https://github.com/eza-community/eza): `ls` replacement

```fish
alias ls 'eza -a1F --color=always --group-directories-first --icons --git' # single column
alias la 'eza -aF --color=always --group-directories-first --icons --git' # all files and dirs
alias ll 'eza -alF --color=always --group-directories-first --icons --git' # long format
alias lt 'eza -aTF --color=always --group-directories-first --icons --git' # tree listing
```

### fzf

- [PatrickF1/fzf.fish](https://github.com/PatrickF1/fzf.fish): `fzf` plugin for fish

```fish
set fzf_preview_dir_cmd eza --all --color=always
set fzf_fd_opts --hidden --exclude=.git

fzf_configure_bindings --directory=\cf
```

### lf file manager

- [gokcehan/lf](https://github.com/gokcehan/lf): terminal file manager ([see my config](../lf/README.md))

```fish
function lf --wraps="lf" --description="lf - Terminal file manager (changing directory on exit)"
    # `command` is needed in case `lfcd` is aliased to `lf`.
    # Quotes will cause `cd` to not change directory if `lf` prints nothing to stdout due to an error.
    cd "$(command lf -print-last-dir $argv)"
end
```

### gnupg

```fish
set -gx GPG_TTY (tty)

gpgconf --launch gpg-agent
```

### oil.nvim

```fish
function oil
    # Select a host via fzf from ~/.ssh/config
    set host (grep 'Host\>' ~/.ssh/config | sed 's/^Host //' | grep -v '\*' | fzf)

    if test -z "$host"
        return 0
    end

    # Get user from host name
    set user (ssh -G "$host" | grep '^user\>' | sed 's/^user //')

    # Open Neovim with oil-ssh URI
    nvim oil-ssh://$user@$host/
end
```

### tmux

```fish
if status is-interactive
and not set -q TMUX
    # exec tmux new -As0
end
```

### Mise

- [jdx/mise](https://github.com/jdx/mise)

```fish
mise activate fish | source

```

## Keybindings

Configuration for fish to work with vi-style bindings.

```fish
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
```

## Appearance

### Theme

- Uses [woheedev/onedark-fish](https://github.com/woheedev/onedark-fish), activate by executing `fish_config theme save "One Dark"`

### Fetch

- [LinusDierheimer/fastfetch](https://github.com/LinusDierheimer/fastfetch)

```fish
function fish_greeting
    fastfetch
end
```

### Prompt

- [starship/starship](https://github.com/starship/starship): custom prompt ([see my config](../starship/README.md))

```fish
set -gx STARSHIP_CONFIG "$XDG_CONFIG_HOME/starship/starship.toml"

function starship_transient_prompt_func
  starship module character
end

function starship_transient_rprompt_func
  starship module time
end

starship init fish | source
enable_transience
```

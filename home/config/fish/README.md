---
tangle: /private/etc/nix-darwin/home/config/fish/config.fish
---

# Fish config

- Configuration is done inside of `README.md` which is tangled to `config.fish`
- Plugins are added via `fish_plugins`
- The other files and directories are managed by fish itself, fisher, Homebrew, ...

## Dependencies

- [fish-shell/fish-shell](https://github.com/fish-shell/fish-shell)
- [Homebrew](https://brew.sh/)
- [A Nerd Font](https://www.nerdfonts.com/)

## Variables

```fish
set -gx PNPM_HOME "$XDG_DATA_HOME/pnpm"

set -gx CC "$HOMEBREW_PREFIX/opt/llvm/bin/clang"
set -gx CXX "$HOMEBREW_PREFIX/opt/llvm/bin/clang++"

```

## Language hooks

Hooks to setup support for language ecosystems

```fish
source /Users/rishab/.local/share/opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

# eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5)"
```

### Config tangling

- [RisGar/gltangle](https://github.com/RisGar/crtangle): tangles this (and other) Markdown file(s) to their respective config files.

```fish
function reload
    gltangle ~/.config/ghostty/README.md
    ghostty +validate-config

    gltangle /etc/nix-darwin/home/config/fish/README.md
    sudo -i darwin-rebuild switch -I /etc/nix-darwin/flake.nix
    source ~/.config/fish/config.fish
end
```

## Software

### bat

- [sharkdp/bat](https://github.com/sharkdp/bat): `cat` replacement
- Installed via nix home-manager

```fish

# work with fd
function fd
    command fd $argv -X bat
end

# alias bat "bat --wrap=never"
```

### zoxide

- [ajeetdsouza/zoxide](https://github.com/ajeetdsouza/zoxide): `cd` replacement
- Installed via nix home-manager

### eza

- [eza-community/eza](https://github.com/eza-community/eza): `ls` replacement

```fish
# alias ls 'eza -F --color=always --group-directories-first --icons=always --git'
# alias ll 'eza -lF --color=always --group-directories-first --icons=always --git'
# alias la 'eza -aF --color=always --group-directories-first --icons=always --git'
# alias lt 'eza -aTF --color=always --group-directories-first --icons=always --git'
# alias lla 'eza -alF --color=always --group-directories-first --icons=always --git'
```

### fzf

- [PatrickF1/fzf.fish](https://github.com/PatrickF1/fzf.fish): `fzf` plugin for fish

```fish
set fzf_preview_dir_cmd eza --all --color=always
set fzf_fd_opts --hidden --exclude=.git

fzf_configure_bindings --directory=\cf
```

### lf file manager

- [gokcehan/lf](https://github.com/gokcehan/lf): terminal file manager ([see my config](../lf/default.nix))

```fish
function lf --wraps="lf" --description="lf - Terminal file manager (changing directory on exit)"
    # `command` is needed in case `lfcd` is aliased to `lf`.
    # Quotes will cause `cd` to not change directory if `lf` prints nothing to stdout due to an error.
    cd "$(command lf -print-last-dir $argv)"
end
```

### gnupg

```fish
# set -gx GPG_TTY (tty)
#
# gpgconf --launch gpg-agent
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

- [woheedev/onedark-fish](https://github.com/woheedev/onedark-fish)

```fish
fish_config theme choose "One Dark"
```

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
function starship_transient_prompt_func
  starship module character
end

function starship_transient_rprompt_func
  starship module time
end
```

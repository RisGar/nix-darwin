set -gx PNPM_HOME "$XDG_DATA_HOME/pnpm"

set -gx CC "$HOMEBREW_PREFIX/opt/llvm/bin/clang"
set -gx CXX "$HOMEBREW_PREFIX/opt/llvm/bin/clang++"

source /Users/rishab/.local/share/opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

# eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5)"
function reload
    gltangle ~/.config/ghostty/README.md
    ghostty +validate-config

    gltangle /etc/nix-darwin/home/config/fish/README.md
    sudo -i darwin-rebuild switch -I /etc/nix-darwin/flake.nix
    source ~/.config/fish/config.fish
end

# work with fd
function fd
    command fd $argv -X bat
end

# alias bat "bat --wrap=never"
# alias ls 'eza -F --color=always --group-directories-first --icons=always --git'
# alias ll 'eza -lF --color=always --group-directories-first --icons=always --git'
# alias la 'eza -aF --color=always --group-directories-first --icons=always --git'
# alias lt 'eza -aTF --color=always --group-directories-first --icons=always --git'
# alias lla 'eza -alF --color=always --group-directories-first --icons=always --git'
set fzf_preview_dir_cmd eza --all --color=always
set fzf_fd_opts --hidden --exclude=.git

fzf_configure_bindings --directory=\cf
function lf --wraps="lf" --description="lf - Terminal file manager (changing directory on exit)"
    # `command` is needed in case `lfcd` is aliased to `lf`.
    # Quotes will cause `cd` to not change directory if `lf` prints nothing to stdout due to an error.
    cd "$(command lf -print-last-dir $argv)"
end
# set -gx GPG_TTY (tty)
#
# gpgconf --launch gpg-agent
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
fish_config theme choose "One Dark"
function fish_greeting
    fastfetch
end
function starship_transient_prompt_func
  starship module character
end

function starship_transient_rprompt_func
  starship module time
end

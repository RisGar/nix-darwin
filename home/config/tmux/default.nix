{ pkgs, config, ... }:
{
  programs.tmux = {
    enable = true;
    mouse = true;
    newSession = true;
    prefix = "C-a";
    extraConfig = ''
      set -g default-terminal "screen-256color"
      set -a terminal-features "tmux-256color:RGB:cnorm=\E[?12h\E[?25h"

      set -g base-index 1
      set -g renumber-windows on   
      set -g mode-keys vi

      set -g status-position top
      set -g status-justify absolute-centre
      set -g status-style "bg=default"
      set -g window-status-current-style "fg=blue bold"
      set -g status-left ""
      set -g status-right " #S"

      set -g history-limit 50000
      set -g focus-events on
      set -gq allow-passthrough all
      set -g detach-on-destroy off  # don't exit from tmux when closing a session

      # Set new panes to open in current directory
      bind c new-window -c "#{pane_current_path}"
      bind - split-window -c "#{pane_current_path}"
      bind | split-window -h -c "#{pane_current_path}"

      bind r source-file "~/.config/tmux/tmux.conf"
      bind b set -g status
      bind e display-popup -b rounded -E  "tmux show-environment -g"
      bind ü copy-mode
      bind x kill-pane # skip "kill-pane? (y/n)" prompt

      bind a run-shell "sesh connect \"$(
        sesh list --icons | fzf --tmux 80%,70% \
          --no-sort --ansi --border-label ' sesh ' --prompt '󱐋  ' \
          --header '  󰘴a all 󰘴t tmux 󰘴g configs 󰘴x zoxide 󰘴d kill 󰘴f find' \
          --bind 'tab:down,btab:up' \
          --bind 'ctrl-a:change-prompt(󱐋  )+reload(sesh list --icons)' \
          --bind 'ctrl-t:change-prompt(  )+reload(sesh list -t --icons)' \
          --bind 'ctrl-g:change-prompt(  )+reload(sesh list -c --icons)' \
          --bind 'ctrl-x:change-prompt(󰉋  )+reload(sesh list -z --icons)' \
          --bind 'ctrl-f:change-prompt(  )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
          --bind 'ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(󱐋  )+reload(sesh list --icons)' \
          --preview-window 'right:55%' \
          --preview 'sesh preview {}'
      )\""

      bind g display-popup -b rounded -E -xC -yC -w 80% -h 80% -d "#{pane_current_path}" lazygit

      bind-key N display-popup -b rounded -E "nvim ~/Documents/Notes/scratch.md"

      # vim like selection keys
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
    '';
  };
}

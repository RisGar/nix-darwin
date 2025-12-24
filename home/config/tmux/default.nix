{
  config,
  lib,
  pkgs,
  ...
}:
let
  seshExe = lib.getExe config.programs.sesh.package;
in
{
  programs.tmux = {
    enable = true;
    mouse = false;
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
      set -g status-right "#S"

      set -g history-limit 50000
      set -g focus-events on
      set -gq allow-passthrough all
      set -g detach-on-destroy off  # don't exit from tmux when closing a session

      set -g clock-mode-style 24

      # Set new panes to open in current directory
      bind c new-window -c "#{pane_current_path}"
      bind - split-window -c "#{pane_current_path}"
      bind | split-window -h -c "#{pane_current_path}"

      bind r source-file "~/.config/tmux/tmux.conf"
      bind b set -g status
      bind ü copy-mode
      bind x kill-pane # skip "kill-pane? (y/n)" prompt

      bind a run-shell "${seshExe} connect \"$(
        ${seshExe} list --icons | ${lib.getExe config.programs.fzf.package} --tmux 80%,70% \
          --no-sort --ansi --border-label ' sesh ' --prompt '󱐋  ' \
          --header '  󰘴a all 󰘴t tmux 󰘴g configs 󰘴x zoxide 󰘴d kill 󰘴f find' \
          --bind 'tab:down,btab:up' \
          --bind 'ctrl-a:change-prompt(󱐋  )+reload(${seshExe} list --icons)' \
          --bind 'ctrl-t:change-prompt(  )+reload(${seshExe} list -t --icons)' \
          --bind 'ctrl-g:change-prompt(  )+reload(${seshExe} list -c --icons)' \
          --bind 'ctrl-x:change-prompt(󰉋  )+reload(${seshExe} list -z --icons)' \
          --bind 'ctrl-f:change-prompt(  )+reload(${lib.getExe config.programs.fd.package} -H -d 2 -t d -E .Trash . ~)' \
          --bind 'ctrl-d:execute(${lib.getExe config.programs.tmux.package} kill-session -t {2..})+change-prompt(󱐋  )+reload(sesh list --icons)' \
          --preview-window 'right:55%' \
          --preview '${seshExe} preview {}'
      )\""

      bind-key g display-popup -b rounded -E -xC -yC -w 80% -h 80% -d "#{pane_current_path}" ${lib.getExe config.programs.lazygit.package} 

      bind-key N display-popup -b rounded -E -w 80% -h 80% "${config.home.sessionVariables.EDITOR} ~/Documents/Notes/scratch.md"

      # vim like selection keys
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
    '';
  };

  programs.sesh = {
    enable = true;
    enableTmuxIntegration = false; # TODO: custom prompt with nerd font instead of emojis via overlay
    settings = {
      default_session = {
        preview_command = "${lib.getExe config.programs.eza.package} -aF --color=always --git --group-directories-first --icons {}";
        startup_command = "${config.home.sessionVariables.EDITOR} -c ':lua Snacks.picker.files(opts)'";
      };

      session = [
        {
          name = "Notes 󰎞 ";
          path = "~/Documents/Notes";
        }
        {
          name = "Nix 󱄅 ";
          path = config.vars.systemFlake;
        }
      ];
    };
  };
}

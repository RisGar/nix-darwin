{ ... }:
{
  programs.fzf = {
    enable = true;

    defaultOptions = [
      "--cycle"
      "--layout=reverse"
      "--border=rounded"
      "--preview-window=border-rounded"
      "--prompt='󰘧  '"
      "--info=right"
    ];

    enableFishIntegration = false; # use fzf.fish
    # Also don't use tmux integration as `fzf-tmux` has been replaced by `--tmux`
  };
}

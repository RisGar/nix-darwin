{
  config,
  lib,
  ...
}:
{
  programs.fzf = {
    enable = true;

    colors = {
      "bg+" = "#${config.colorScheme.palette.base01}";
      spinner = "#${config.colorScheme.palette.base0C}";
      hl = "#${config.colorScheme.palette.base0D}";
      header = "#${config.colorScheme.palette.base0D}";
      info = "#${config.colorScheme.palette.base0A}";
      pointer = "#${config.colorScheme.palette.base0C}";
      marker = "#${config.colorScheme.palette.base0C}";
      prompt = "#${config.colorScheme.palette.base0A}";
      "hl+" = "#${config.colorScheme.palette.base0D}";
    };

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

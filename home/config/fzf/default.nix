{
  config,
  lib,
  ...
}:
{
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
}

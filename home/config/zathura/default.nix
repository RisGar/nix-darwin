{ pkgs, ... }:
{
  programs.zathura = {
    enable = true;
    mappings = {
      "r" = "reload";
      "R" = "rotate";
      "p" = "print";
      "i" = "recolor";
      "f" = "toggle_fullscreen";
      "[fullscreen]f" = "toggle_fullscreen";
    };
    options = {
      # open document in fit-width mode by default
      adjust-open = "best-fit";

      # one page per row by default
      pages-per-row = 1;

      # stop at page boundries
      scroll-page-aware = true;
      scroll-full-overlap = 0.01;
      scroll-step = 50;

      # zoom settings
      zoom-min = 10;

      # guioptions
      # 'c', => command line
      # 's', => statusbar
      # 'h', => horizontal scrollbar
      # 'v', => vertical scrollbar
      guioptions = "cs";

      # onedark
      # set notification-error-bg "#3e4452"
      # set notification-error-fg "#c678dd"
      # set notification-warning-bg "#3e4452"
      # set notification-warning-fg "#c678dd"
      # set notification-bg "#3e4452"
      # set notification-fg "#c678dd"
      # set completion-group-bg "#3e4452"
      # set completion-group-fg "#e5c07b"

      font = "maple mono nf cn 15";
      default-bg = "rgba(40, 44, 52, 0.9)";
      default-fg = "#ABB2BF";

      # this somehow inherits the bg with working transparency
      statusbar-bg = "nil";
      statusbar-fg = "#ABB2BF";

      # this somehow inherits the bg with working transparency
      inputbar-bg = "nil";
      inputbar-fg = "#ABB2BF";

      notification-error-bg = "#AC4142";
      notification-error-fg = "#151515";

      notification-warning-bg = "#AC4142";
      notification-warning-fg = "#151515";

      highlight-color = "rgba(229, 192, 123, 0.5)";
      highlight-active-color = "rgba(224, 108, 117, 0.5)";

      completion-highlight-bg = "#E5C07B";
      completion-highlight-fg = "#3E4452";

      completion-bg = "#21252B";
      completion-fg = "#ABB2BF";

      notification-bg = "#90A959";
      notification-fg = "#151515";

      # this somehow inherits the bg with working transparency
      index-bg = "nil";
      index-fg = "#ABB2BF";

      index-active-bg = "#61AFEF";
      index-active-fg = "#ABB2BF";

      recolor = false;
      recolor-lightcolor = "rgba(40, 44, 52, 0.9)";
      recolor-darkcolor = "#ABB2BF";
      recolor-reverse-video = true;
      recolor-keephue = true;

      selection-clipboard = "clipboard";

      render-loading = false;
    };
    package = pkgs.zathura.override {
      useMupdf = true;
      zathura_core = pkgs.zathuraPkgs.zathura_core.overrideAttrs (previousAttrs: {
        patches = (previousAttrs.patches or [ ]) ++ [
          (
            pkgs.fetchFromGitHub {
              owner = "homebrew-zathura";
              repo = "homebrew-zathura";
              rev = "d199fece0240d0439494cf141b7c9d1c785ac784";
              hash = "sha256-pE8d1idBFfBT5hsnOO/WN9BLC4FErDc/TsiSDGAvB/E=";
            }
            + "/patches/mac-integration.diff"
          )
        ];
      });
    };
  };
}

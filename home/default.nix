{ pkgs, ... }:
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "rishab";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.fish = {
    enable = true;
    shellInit = builtins.readFile config/fish/config.fish;
    plugins = [
      {
        name = "fzf.fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
    ];
  };

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "onedark"; # TODO: fix
      theme_background = false;
    };
  };

  programs.sesh = {
    enable = true;
    enableTmuxIntegration = false; # Use custom prompt with nerd font instead of emojis
    settings = builtins.fromTOML ''
      [default_session]
      preview_command = "eza -aF --color=always --git --group-directories-first --icons {}"
      startup_command = "nvim -c ':lua Snacks.picker.files(opts)'"

      [[session]]
      name = "Notes 󰎞"
      path = "~/Documents/Notes"

      [[session]]
      name = "Nix 󱄅"
      path = "/etc/nix-darwin"
    '';
  };

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

  programs.zoxide = {
    enable = true;
  };

  # TODO: ghostty, bat
}

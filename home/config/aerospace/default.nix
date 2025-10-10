{ pkgs, config, ... }:
{
  xdg.configFile."aerospace/pip-move.fish".source = ./pip-move.fish;
  programs.aerospace = {
    enable = true;
    launchd.enable = true;
    userSettings = builtins.fromTOML (builtins.readFile ./aerospace.toml) // {
      # Make PiP follow workspace
      exec-on-workspace-change = [
        "${pkgs.fish}/bin/fish"
        "${config.xdg.configHome}/aerospace/pip-move.fish"
      ];
    };
  };
}

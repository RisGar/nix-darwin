{ config, ... }:
{
  xdg.configFile."sketchybar/plugins/aerospace.sh" = {
    source = ./plugins/aerospace.sh;
    executable = true;
  };
  xdg.configFile."sketchybar/plugins/battery.sh" = {
    source = ./plugins/battery.sh;
    executable = true;
  };
  xdg.configFile."sketchybar/plugins/clock.sh" = {
    text = ''
      #!/bin/sh
      sketchybar --set "$NAME" label="$(date '+%d/%m %H:%M')"
    '';
    executable = true;
  };
  xdg.configFile."sketchybar/plugins/front_app.sh" = {
    text = ''
      #!/bin/sh
      if [ "$SENDER" = "front_app_switched" ]; then
        sketchybar --set "$NAME" label="$INFO"
      fi
    '';
    executable = true;
  };
  xdg.configFile."sketchybar/plugins/space_windows.sh" = {
    source = ./plugins/space_windows.sh;
    executable = true;
  };
  xdg.configFile."sketchybar/plugins/volume.sh" = {
    source = ./plugins/volume.sh;
    executable = true;
  };

  programs.sketchybar = {
    enable = false;
    extraPackages = [
      config.programs.aerospace.package
    ];
    config = {
      text = builtins.readFile ./sketchybarrc;
    };
  };
}

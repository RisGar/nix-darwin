{
  config,
  lib,
  ...
}:
{
  programs.sioyek = {
    enable = true;
    bindings = {
      "toggle_custom_color" = "i";
    };
    config = {
      "ui_font" = "Maple Mono NF CN";
      "font_size" = "15";

      "fit_to_page_width_on_open" = "1";
    };
  };
}

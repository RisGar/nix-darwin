{
  pkgs,
  ...
}:
{
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    keymap = {
      mgr.prepend_keymap = [
        {
          on = [ "y" ];
          run = [
            "yank"
            "plugin clippy"
          ];
        }
      ];
    };
    plugins = {
      inherit (pkgs.yaziPlugins) clippy;
    };
  };
}

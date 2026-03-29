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
          run = "plugin system-clipboard";
          on = "<C-y>";
        }
      ];
    };
    plugins = {
      inherit (pkgs.yaziPlugins) system-clipboard;
    };
  };
}

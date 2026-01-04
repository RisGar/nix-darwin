{ lib, pkgs, ... }:
{
  xdg.configFile."lf/icons".source = ./icons;
  programs.lf = {
    enable = true;
    previewer = {
      source = lib.getExe pkgs.mlpreview;
      keybinding = "i"; # TODO: override less with pager in overlay
    };
    extraConfig = builtins.readFile ./lfrc;
    cmdKeybindings = {
      r = "rename";
      D = "delete";
      x = "cut";
      y = "copy";
      d = "";
      R = "reload";
      p = "paste";
    };
    commands = {
      trash = "%trash -F $fx";
      copy-path = "$printf '%s' \"$fx\" | pbcopy";
      q = "quit";
      make-exec = "%chmod 755 $f && lf -remote \"send $id reload\"";
      make-normal = "%chmod 644 $f && lf -remote \"send $id reload\"";
    };
    keybindings = {
      "<c-d>" = "trash";
      Y = "copy-path";
      "<c-e>" = "make-exec";
      "<c-n>" = "make-normal";
    };
  };
}

{ pkgs, ... }:

let
  jdks = with pkgs; [
    jdk17
    jdk25
  ];
in
{

  programs.java = {
    enable = true;
    package = pkgs.jdk21;
  };

  home.sessionPath = [ "$HOME/.jdks" ];
  home.file = (
    builtins.listToAttrs (
      builtins.map (jdk: {
        name = ".jdks/${jdk.version}";
        value = {
          source = jdk;
        };
      }) jdks
    )
  );
}

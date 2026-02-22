{
  pkgs,
  config,
  lib,
  ...
}:

{
  vars.jdks = with pkgs; [
    jdk17
    jdk21
    jdk25
  ];

  home.activation = lib.listToAttrs (
    lib.map (
      jdk:
      lib.nameValuePair "java-${lib.versions.major jdk.version}" (
        lib.hm.dag.entryAfter [ "writeBoundary" ] (
          lib.concatStringsSep " " [
            "run ln -sf $VERBOSE_ARG"
            (
              jdk.outPath + "/Library/Java/JavaVirtualMachines/zulu-" + (lib.versions.major jdk.version) + ".jdk/"
            )
            ("/Library/Java/JavaVirtualMachines/zulu-" + (lib.versions.major jdk.version) + ".jdk/")
          ]
        )
      )
    ) config.vars.jdks
  );

  home.sessionVariables = {
    JAVA_HOME = "$(/usr/libexec/java_home)";
  };
  home.sessionPath = [ "${config.home.sessionVariables.JAVA_HOME}/bin" ];

}

{ config, lib, ... }:

{
  nvim = {
    enable = true;
    packageDefinitions.replace = {
      nvim =
        { pkgs, name, ... }:
        {
          extra = lib.listToAttrs (
            lib.map (
              jdk: lib.nameValuePair "java-${lib.versions.major jdk.version}" jdk.outPath
            ) config.vars.jdks
          );
        };
    };

  };
}

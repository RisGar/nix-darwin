{ config, lib, ... }:

{
  nvim = {
    enable = true;
    packageDefinitions.replace = {
      nvim =
        { pkgs, name, ... }:
        {
          extra = builtins.listToAttrs (
            builtins.map (jdk: {
              name = "java-${lib.versions.major jdk.version}";
              value = jdk.outPath;
            }) config.vars.jdks
          );
        };
    };

  };
}

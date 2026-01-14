lib:

import ./secrets.nix
|> builtins.attrNames
|> builtins.map (n: lib.nameValuePair (lib.removeSuffix ".age" n) { file = ./${n}; })
|> builtins.listToAttrs

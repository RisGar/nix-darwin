let
  rishabs-macbook = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJWmextJLZ2oObSyUPW0pqUq9nnSWuZkieDB+CaY9hLy";
  rishabs-homelab = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF+74XpLMdeUesLv6mGZIdqItpITQexLj9IVdeuzAnV5";

  keys = [
    rishabs-macbook
    rishabs-homelab
  ];

  secrets = [
    "homelab-rishab"
    "homelab-root"
    "transmission-openvpn"
    "pangolin"
    "newt"
    "pocket-id"
    "context7"
    "tavily"
    "anilist-mal-sync"
    "open-webui"
    "homarr"
    "cloudflared"
    "openrouter"
  ];
in
secrets
|> builtins.map (secret: {
  name = secret + ".age";
  value.publicKeys = keys;
})
|> builtins.listToAttrs

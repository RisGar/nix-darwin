let
  rishabs-macbook = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJWmextJLZ2oObSyUPW0pqUq9nnSWuZkieDB+CaY9hLy";
  rishabs-homelab = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF+74XpLMdeUesLv6mGZIdqItpITQexLj9IVdeuzAnV5";
in
{
  "homelab-rishab.age".publicKeys = [
    rishabs-macbook
    rishabs-homelab
  ];
  "homelab-root.age".publicKeys = [
    rishabs-macbook
    rishabs-homelab
  ];
  "transmission-openvpn.age".publicKeys = [
    rishabs-macbook
    rishabs-homelab
  ];
  "cloudflare.age".publicKeys = [
    rishabs-macbook
    rishabs-homelab
  ];
  "pangolin.age".publicKeys = [
    rishabs-macbook
    rishabs-homelab
  ];
  "newt.age".publicKeys = [
    rishabs-macbook
    rishabs-homelab
  ];
}

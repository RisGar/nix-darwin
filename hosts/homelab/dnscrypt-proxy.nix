{ ... }:
{

  services.dnscrypt-proxy = {
    enable = false;
    settings = {
      ipv4_servers = true;
      ipv6_servers = true;

      dnscrypt_servers = true;
      doh_servers = true;

      require_dnssec = true;
      require_nolog = true;
      require_nofilter = true;

      http3 = true;

      sources = {
        public-resolvers = {
          urls = [
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
            "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
          ];
          cache_file = "/var/cache/dnscrypt-proxy/public-resolvers.md";
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        };
        relays = {
          urls = [
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/relays.md"
            "https://download.dnscrypt.info/resolvers-list/v3/relays.md'"
          ];
          cache_file = "/var/cache/dnscrypt-proxy/relays.md";
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        };
      };

      forwarding_rules = ../common/forwarding-rules.conf;

      monitoring_ui = {
        enabled = true;
        enable_query_log = true;
        listen_address = "127.0.0.1:8357";
        privacy_level = 1;
      };
    };

  };
}

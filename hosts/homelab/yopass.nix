{ ... }:
{
  services.memcached = {
    enable = true;
  };

  virtualisation.oci-containers.containers.yopass = {
    image = "jhaals/yopass";
    environment = {
      TRUSTED_PROXIES = "pass.homelab.rishab-garg.me";
      PORT = "8282";
      DISABLE_FEATURES = "true";
      DISABLE_UPLOAD = "true";
      METRICS_PORT = "9144";
    };
    cmd = [
      "--memcached=127.0.0.1:11211"
    ];
    networks = [
      "host"
    ];
  };
}

{ config, pkgs, ... }:
{
  services.grafana = {
    enable = true;
    openFirewall = true;
    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = 3000;
        enable_gzip = true;
        root_url = "https://metrics.homelab.rishab-garg.me/";
      };

      analytics.reporting_enabled = false;
    };
    # declarativePlugins = with pkgs.grafanaPlugins; [ ];

    provision = {
      enable = true;

      datasources.settings.datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          url = "http://${config.services.prometheus.listenAddress}:${toString config.services.prometheus.port}";
          isDefault = true;
          editable = false;
        }
      ];
    };
  };

  services.prometheus = {
    enable = true;
    port = 9090;

    exporters = {
      node = {
        enable = true;
        enabledCollectors = [
          "systemd"
        ];
        port = 9002;
      };
    };

    scrapeConfigs = [
      {
        job_name = "prometheus";
        static_configs = [
          {
            targets = [ "127.0.0.1:${toString config.services.prometheus.port}" ];
          }
        ];
      }
      {
        job_name = "node";
        static_configs = [
          {
            targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
          }
        ];
      }
      {
        job_name = "yopass";
        static_configs = [
          {
            targets = [
              "127.0.0.1:${toString config.virtualisation.oci-containers.containers.yopass.environment.METRICS_PORT}"
            ];
          }
        ];
      }
    ];
  };
}

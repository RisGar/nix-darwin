{ config, ... }:
{
  virtualisation.oci-containers.containers.transmission-openvpn = {
    volumes = [
      "/mnt/external/Transmission:/data"
      "/home/rishab/docker/torrent/config:/config"
    ];
    environmentFiles = [ config.age.secrets.transmission-openvpn.path ];
    environment = {
      OPENVPN_PROVIDER = "NORDVPN";
      NORDVPN_PROTOCOL = "tcp";
      NORDVPN_CATEGORY = "legacy_p2p";
      NORDVPN_COUNTRY = "DE";
      TRANSMISSION_DOWNLOAD_DIR = "/data/completed";
      TZ = "Europe/Berlin";
      LOCAL_NETWORK = "192.168.178.0/24";
    };
    log-driver = "json-file";
    ports = [ "9091:9091" ];
    image = "haugene/transmission-openvpn";
    privileged = true;
  };
}

{ config, ... }:

{
  # The 'd' ensures the folder exists but DOES NOT delete contents.
  systemd.tmpfiles.rules = [
    "d /var/lib/homarr/appdata 0755 root root"
  ];

  virtualisation.oci-containers.containers.homarr = {
    image = "ghcr.io/homarr-labs/homarr:latest";
    ports = [ "7575:7575" ];
    environmentFiles = [
      config.age.secrets.homarr.path
    ];
    volumes = [
      "/var/run/docker.sock:/var/run/docker.sock"
      "/var/lib/homarr/appdata:/appdata"
    ];
  };
}

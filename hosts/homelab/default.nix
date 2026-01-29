{
  modulesPath,
  pkgs,
  config,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
    ./hardware-configuration.nix
    ./metrics.nix
    ./nfs.nix
    ./samba.nix
    ./transmission.nix
    ./yopass.nix
  ];

  # nixos-anywhere --flake .#homelab --generate-hardware-config nixos-generate-config ./hosts/homelab/hardware-configuration.nix <hostname>

  services.qemuGuest.enable = true;

  boot = {
    loader.grub = {
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
    };

    growPartition = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    podman-compose
  ];

  # security.sudo.wheelNeedsPassword = false; # Don't ask for passwords
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  programs.ssh.startAgent = true;

  users.users.root = {
    hashedPasswordFile = config.age.secrets.homelab-root.path;
  };

  users.users.rishab = {
    isNormalUser = true;
    hashedPasswordFile = config.age.secrets.homelab-rishab.path;
    description = "default user";
    extraGroups = [
      "networkmanager"
      "wheel"
      "podman"
      "samba"
      "users"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPktLCANAvs2+iMzZqzLx5mSi5PrYZmWoPTQK112Eyst"
    ];
  };

  system.stateVersion = "25.11";

  nix.settings = {
    trusted-users = [
      "root"
      "@wheel"
    ];
    experimental-features = [
      "nix-command"
      "flakes"
      "pipe-operators"
    ];
  };

  virtualisation.containers.enable = true;
  virtualisation.oci-containers.backend = "podman";
  virtualisation.podman = {
    enable = true;
    dockerSocket.enable = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  fileSystems = {
    "/mnt/external" = {
      device = "/dev/disk/by-uuid/030f15d4-3c55-403f-b6e1-de2abd2912e0";
      fsType = "ext4";
    };
    "/export/external" = {
      device = "/mnt/external";
      options = [ "bind" ];
    };
  };

  networking = {
    hostName = "Rishabs-Homelab";

    firewall.enable = true;

    usePredictableInterfaceNames = true;

    defaultGateway = "192.168.178.1";
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];

    interfaces.ens18.ipv4.addresses = [
      {
        address = "192.168.178.42";
        prefixLength = 24;
      }
    ];
  };

  security.sudo = {
    wheelNeedsPassword = false;
    execWheelOnly = true;
  };

  services.newt = {
    enable = true;
    settings = {
      endpoint = "https://pangolin.homelab.rishab-garg.me";
      docker-socket = "unix:///var/run/docker.sock";
    };
    environmentFile = config.age.secrets.newt.path;
  };

  services.stirling-pdf = {
    enable = true;
    environment = {
      SECURITY_ENABLELOGIN = "true";
    };
  };

}

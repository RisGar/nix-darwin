{
  linuxPkgs,
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
    podman
    podman-compose
    podman-tui
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
    linger = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO9DpYnih3E0xt3A7ra5h+ecrpXf0+/aZjcmAI/0YkWZ"
    ];
  };

  nixpkgs.pkgs = linuxPkgs;

  system.stateVersion = "25.11";

  nix.settings.trusted-users = [
    "root"
    "@wheel"
  ];
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
    "pipe-operators"
  ];
  virtualisation = {
    containers.enable = true;

    oci-containers.containers = {
      transmission-openvpn = {
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
    };
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

  services.nfs.server = {
    enable = true;
    exports = ''
      /export          192.168.178.0/24(rw,fsid=0,no_subtree_check,crossmnt,insecure)
      /export/external 192.168.178.0/24(rw,nohide,insecure,no_subtree_check)
    '';
  };

  networking = {
    hostName = "Rishabs-Homelab";

    firewall = {
      enable = true;
      allowedTCPPorts = [
        2049
      ];
    };

    defaultGateway = "192.168.178.1";
    nameservers = [ "8.8.8.8" ];

    useDHCP = false;
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

  services.samba = {
    enable = true;
    # package = pkgs.samba4Full;
    usershares.enable = true;
    openFirewall = true;
    settings = {
      "tm_share" = {
        "path" = "/mnt/external/TimeMachine";
        "valid users" = "rishab";
        "public" = "no";
        "writeable" = "yes";
        "fruit:aapl" = "yes";
        "fruit:time machine" = "yes";
        "fruit:time machine max size" = "1T";
        "vfs objects" = "catia fruit streams_xattr";
      };
    };
  };

  system.activationScripts = {
    init_smbpasswd.text = ''
      /run/current-system/sw/bin/printf "$(/run/current-system/sw/bin/cat ${config.age.secrets.homelab-rishab.path})\n$(/run/current-system/sw/bin/cat ${config.age.secrets.homelab-rishab.path})\n" | /run/current-system/sw/bin/smbpasswd -sa rishab
    '';
  };

}

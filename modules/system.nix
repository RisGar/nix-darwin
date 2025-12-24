{ pkgs, self, ... }:
{
  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";
  nix.channel.enable = false;

  # User setup
  system.primaryUser = "rishab";
  users.users."rishab".home = "/Users/rishab";

  # Fish shell setup
  programs.fish.enable = true;
  environment.shells = [
    pkgs.fish
  ];
  users.users."rishab".shell = pkgs.fish;

  # Use Touch ID or Apple Watch for sudo auth
  security.pam.services.sudo_local.touchIdAuth = true;
  security.pam.services.sudo_local.reattach = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  system.startup.chime = true;

  system.defaults = {
    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.0;

      tilesize = 54;
      largesize = 70;

      show-recents = false;

      wvous-tl-corner = 10; # Put display to sleep
      wvous-tr-corner = 13; # Lock Screen

      expose-group-apps = true;
      launchanim = true;
      mineffect = "scale";
    };

    hitoolbox.AppleFnUsageType = "Show Emoji & Symbols";

    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      FXEnableExtensionChangeWarning = false;
      FXRemoveOldTrashItems = false;
      NewWindowTarget = "Documents";
      ShowHardDrivesOnDesktop = false;
      ShowExternalHardDrivesOnDesktop = false;
      ShowRemovableMediaOnDesktop = false;
      ShowMountedServersOnDesktop = false;
      ShowPathbar = true;
      ShowStatusBar = false;
    };

    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;

    iCal = {
      CalendarSidebarShown = true;
      "first day of week" = "System Setting";
    };

    menuExtraClock = {
      FlashDateSeparators = false;
      IsAnalog = false;
      Show24Hour = true;
      ShowDate = 0; # When space allows
      ShowDayOfMonth = true;
      ShowDayOfWeek = true;
      ShowSeconds = false;
    };

    ActivityMonitor = {
      IconType = 0;
      OpenMainWindow = true;
      ShowCategory = 100;
    };

    LaunchServices.LSQuarantine = true; # TODO: do i need quarantine
  };

  nixpkgs.hostPlatform = "aarch64-darwin";

  time.timeZone = "Europe/Berlin";

  nix.optimise.automatic = true;
  nix.gc.automatic = true;

  services.dnscrypt-proxy = {
    enable = true;
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
          cache_file = "public-resolvers.md";
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        };
        relays = {
          urls = [
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/relays.md"
            "https://download.dnscrypt.info/resolvers-list/v3/relays.md'"
          ];
          cache_file = "relays.md";
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        };
      };

      forwarding_rules = ./forwarding-rules.conf;

      monitoring_ui = {
        enabled = true;
      };
    };

  };

  launchd.daemons.dnscrypt-proxy.serviceConfig.UserName = pkgs.lib.mkForce "root";

  networking = {
    knownNetworkServices = [
      "Wi-Fi"
      "USB 10/100/1000 LAN"
    ];
    dns = [
      "::1"
      "127.0.0.1"
    ];
  };

  nix.settings.substituters = [
    "https://nvim-treesitter-main.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "nvim-treesitter-main.cachix.org-1:cbwE6blfW5+BkXXyeAXoVSu1gliqPLHo2m98E4hWfZQ="
  ];
  nix.settings.trusted-users = [
    "rishab"
  ];

}

{
  lib,
  pkgs,
  self,
  agenix,
  nixln-edit,
  mlpreview,
  ...
}:
let
  homebrew-zathura = pkgs.fetchFromGitHub {
    owner = "homebrew-zathura";
    repo = "homebrew-zathura";
    rev = "082b515e2f5d3ca88b03d3a9826fe08ed5951cfb";
    hash = "sha256-pE8d1idBFfBT5hsnOO/WN9BLC4FErDc/TsiSDGAvB/E=";
  };
in
{
  imports = [
    ./brew.nix
  ];

  nix = {
    settings.trusted-users = [ "rishab" ];
    linux-builder.enable = false;
    optimise.automatic = true;
  };

  nixpkgs.config = {
    allowBroken = true;
    allowUnfree = true;
  };

  nixpkgs.hostPlatform = "aarch64-darwin";

  nixpkgs.overlays = [
    agenix.overlays.default
    mlpreview.overlays.default

    (final: prev: {
      thaw = prev.callPackage ../../pkgs/thaw.nix { };
      mole-mac = prev.callPackage ../../pkgs/mole-mac.nix { };

      github-copilot-cli = prev.github-copilot-cli.overrideAttrs (old: rec {
        version = "1.0.10";
        src = prev.fetchurl {
          url = "https://github.com/github/copilot-cli/releases/download/v${version}/copilot-darwin-arm64.tar.gz";
          hash = "sha256-kg76xm3UPXJZ8ibz62rLXjgGIGnpaTO06LCcPltPlhc=";
        };
      });

      whatsapp-for-mac = prev.whatsapp-for-mac.overrideAttrs (old: rec {
        version = "2.26.11.21";
        src = prev.fetchzip {
          extension = "zip";
          name = "WhatsApp.app";
          url = "https://web.whatsapp.com/desktop/mac_native/release/?version=${version}&extension=zip&configuration=Release&branch=master";
          hash = "sha256-2/h/rVcNCRP5DVVudIPlISJSn0TV2b2I9HfNu5Zi9UE=";
        };
      });

      nixln-edit = prev.callPackage nixln-edit { };

      yaziPlugins = prev.yaziPlugins // {
        system-clipboard = prev.callPackage (
          {
            fetchFromGitHub,
          }:
          prev.yaziPlugins.mkYaziPlugin {
            pname = "system-clipboard.yazi";
            version = "0-unstable-2026-03-29";

            installPhase = ''
              runHook preInstall

              cp -r . $out

              runHook postInstall
            '';

            src = fetchFromGitHub {
              owner = "orhnk";
              repo = "system-clipboard.yazi";
              rev = "75a53300bed1946c6d488d42efc34864ea26ca85";
              hash = "sha256-djvSPRHjP9bc4eXTiHwty4byVgVFRBDvfNYlX/nHVaw=";
            };
          }
        ) { };
      };

      zathuraPackages = prev.zathuraPackages // {
        zathura_core = prev.zathuraPkgs.zathura_core.overrideAttrs (old: {
          patches = old.patches ++ [
            (homebrew-zathura + "/patches/mac-integration.diff")
          ];
        });
      };
    })

  ];

  services.virby = {
    enable = false;
    cores = 4;
    onDemand = {
      enable = true;
      ttl = 30; # in mins
    };
    rosetta = true;
  };

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
    "pipe-operators"
  ];

  nix.channel.enable = false;

  # User setup
  system.primaryUser = "rishab";
  users.users."rishab" = {
    name = "rishab";
    home = "/Users/rishab";
    shell = pkgs.fish;
  };

  # Fish shell setup
  programs.fish.enable = true;
  environment.shells = [
    pkgs.fish
  ];

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

  time.timeZone = "Europe/Berlin";

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

      forwarding_rules = ../common/forwarding-rules.conf;

      monitoring_ui = {
        enabled = true;
        enable_query_log = true;
        listen_address = "127.0.0.1:6969";
        privacy_level = 1;
      };
    };

  };

  launchd.daemons.dnscrypt-proxy.serviceConfig.UserName = lib.mkForce "root";

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

}

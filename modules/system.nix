{ pkgs, ... }:
{

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # User setup
  system.primaryUser = "rishab";
  users.users."rishab".home = "/Users/rishab";

  # Fish shell setup
  programs.fish.enable = true;
  environment.shells = [
    pkgs.fish
  ];
  users.users."rishab".shell = pkgs.fish;

  # Direnv
  programs.direnv.enable = true;

  # Use Touch ID or Apple Watch for sudo auth
  security.pam.services.sudo_local.touchIdAuth = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  system.defaults = {
    menuExtraClock.Show24Hour = true;

    dock = {
      autohide = true;
      autohide-delay = 0.0;

      tilesize = 54;
      largesize = 70;

      show-recents = false;

      wvous-tl-corner = 10; # Put display to sleep
      wvous-tr-corner = 13; # Lock Screen
    };
  };

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  time.timeZone = "Europe/Berlin";

  # Nix store optimization
  nix.optimise.automatic = true;

}

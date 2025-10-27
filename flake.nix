{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    unison-lang = {
      url = "github:ceedubs/unison-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mlpreview = {
      url = "github:RisGar/mlpreview";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };
  outputs =
    inputs@{
      self,
      nix-darwin,
      nix-homebrew,
      nixpkgs,
      home-manager,
      unison-lang,
      mlpreview,
      ...
    }:
    let

      pkgs = import nixpkgs {
        system = "aarch64-darwin";
        overlays = [
          unison-lang.overlay
          mlpreview.overlay
        ];
      };
    in
    {
      # Build darwin flake using:
      # $ sudo -i darwin-rebuild build --flake .#Rishabs-MacBook-Pro
      darwinConfigurations."Rishabs-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        modules = [
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              # Install Homebrew under the default prefix
              enable = true;

              # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
              enableRosetta = false;

              # User owning the Homebrew prefix
              user = "rishab";

              # Automatically migrate existing Homebrew installations
              autoMigrate = true;

              # Declarative tap management
              # taps = {
              #   "homebrew/homebrew-core" = inputs.homebrew-core;
              #   "homebrew/homebrew-cask" = inputs.homebrew-cask;
              # };
            };
          }

          ./modules/system.nix
          ./modules/apps.nix

          home-manager.darwinModules.home-manager
          {

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."rishab" = ./home;
            home-manager.backupFileExtension = "bak";

            home-manager.extraSpecialArgs = {
              inherit inputs;
              inherit pkgs;
              mlpreview = mlpreview;
            };
          }
        ];
        specialArgs = {
          inherit inputs;
          flake-self = self;
        };
      };
    };
}

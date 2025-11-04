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

    # Homebrew taps
    # homebrew-core = {
    #   url = "github:homebrew/homebrew-core";
    #   flake = false;
    # };
    # homebrew-cask = {
    #   url = "github:homebrew/homebrew-cask";
    #   flake = false;
    # };
    # homebrew-numi = {
    #   url = "https://github.com/nikolaeu/homebrew-numi";
    #   flake = false;
    # };
    # homebrew-sikarugir = {
    #   url = "https://github.com/Sikarugir-App/homebrew-sikarugir";
    #   flake = false;
    # };
  };
  outputs =
    inputs@{
      home-manager,
      nix-darwin,
      nix-homebrew,
      nixpkgs,
      self,
      ...
    }:
    let
      pkgs = import nixpkgs {
        system = "aarch64-darwin";
        overlays = [
          inputs.unison-lang.overlay
          inputs.mlpreview.overlay
        ];
        config = {
          allowUnfree = true;
        };
      };
    in
    {
      # Build darwin flake using:
      # $ sudo -i darwin-rebuild build --flake .#Rishabs-MacBook-Pro
      darwinConfigurations."Rishabs-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        modules = [
          ./modules/system.nix
          ./modules/brew.nix

          home-manager.darwinModules.home-manager
          nix-homebrew.darwinModules.nix-homebrew

          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users."rishab" = ./home;
              backupFileExtension = "bak";

              extraSpecialArgs = {
                inherit inputs;
                inherit pkgs;
              };
            };

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
              # TODO: can I make this work without uninstalling homebrew?
              # taps = {
              #   "homebrew/homebrew-core" = inputs.homebrew-core;
              #   "homebrew/homebrew-cask" = inputs.homebrew-cask;
              #   "nikolaeu/homebrew-numi" = inputs.homebrew-numi; # numi cli
              #   "sikarugir-app/homebrew-sikarugir" = inputs.homebrew-sikarugir;
              # };
              #
              # mutableTaps = true;
            };
          }

        ];
        specialArgs = {
          inherit inputs;
          inherit pkgs;
          flake-self = self;
        };
      };
    };
}

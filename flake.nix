{
  description = "nix-darwin system flake";

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

    mlpreview = {
      url = "github:RisGar/mlpreview";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    nixln-edit = {
      url = "github:nlintn/nixln-edit";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim-config = {
      url = "path:///Users/rishab/Documents/Programming/nvim-config";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Homebrew taps
    # homebrew-core = {
    #   url = "github:homebrew/homebrew-core";
    #   flake = false;
    # };
    # homebrew-cask = {
    #   url = "github:homebrew/homebrew-cask";
    #   flake = false;
    # };
    # homebrew-sikarugir = {
    #   url = "https://github.com/Sikarugir-App/homebrew-sikarugir";
    #   flake = false;
    # };
  };
  outputs =
    {
      # homebrew-cask,
      # homebrew-core,
      # homebrew-sikarugir,
      home-manager,
      mlpreview,
      nix-darwin,
      nix-homebrew,
      nixln-edit,
      nixpkgs,
      nvim-config,
      self,
      ...
    }:
    let
      system = "aarch64-darwin";
    in
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          mlpreview.overlays.default
          (final: prev: { nixln-edit = nixln-edit.packages.${system}.default; })
        ];
        config = {
          allowUnfree = true;
        };
      };
      secrets = builtins.fromTOML (builtins.readFile ./secrets/secrets.toml);
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
                inherit pkgs;
                inherit nvim-config;
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
              #   "homebrew/homebrew-core" = homebrew-core;
              #   "homebrew/homebrew-cask" = homebrew-cask;
              #   "sikarugir-app/homebrew-sikarugir" = homebrew-sikarugir;
              # };
              # mutableTaps = true;
            };
          }

        ];
        specialArgs = {
          inherit pkgs;
          inherit secrets;
          inherit self;
        };
      };
    };
}

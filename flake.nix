{
  description = "nix-darwin and nixos system flake";

  outputs =
    {
      # homebrew-cask,
      # homebrew-core,
      # homebrew-sikarugir,
      agenix,
      disko,
      home-manager,
      mlpreview,
      nix-colors,
      nix-darwin,
      nix-homebrew,
      nixln-edit,
      nixpkgs,
      nvim-config,
      self,
      nix-rosetta-builder,
      ...
    }:
    let
      darwinPkgs = import nixpkgs rec {
        system = "aarch64-darwin";
        overlays = [
          mlpreview.overlays.default
          (final: prev: { nixln-edit = nixln-edit.packages.${system}.default; })
        ];
        config = {
          allowUnfree = true;
        };
      };
      linuxPkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ ];
        config = { };
      };

      lib = nixpkgs.lib;

      secrets = import ./secrets lib;
    in
    {
      # Build darwin flake using:
      # $ sudo -i darwin-rebuild build --flake .#Rishabs-MacBook-Pro
      darwinConfigurations."Rishabs-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        system = darwinPkgs.system;
        modules = [
          nix-rosetta-builder.darwinModules.default
          {
            # see available options in module.nix's `options.nix-rosetta-builder`
            nix-rosetta-builder.onDemand = true;
          }

          ./hosts/macbook

          home-manager.darwinModules.default
          nix-homebrew.darwinModules.default

          agenix.darwinModules.default
          {
            age.secrets = secrets;
          }

          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users."rishab" = ./home/rishab;
              backupFileExtension = "bak";

              extraSpecialArgs = {
                inherit nvim-config;
                inherit nix-colors;
              };
            };

            nix-homebrew = {
              enable = true;
              enableRosetta = false;
              user = "rishab";
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
          inherit darwinPkgs;
          inherit self;
        };
      };

      nixosConfigurations."Rishabs-Homelab" = nixpkgs.lib.nixosSystem {
        system = linuxPkgs.system;

        modules = [
          disko.nixosModules.default

          agenix.nixosModules.default
          {
            age.secrets = secrets;
          }

          ./hosts/homelab
        ];

        specialArgs = {
          inherit linuxPkgs;
          inherit self;
        };
      };
    };

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
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
    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
    };
    nixln-edit = {
      url = "github:nlintn/nixln-edit";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim-config = {
      url = "github:RisGar/nvim-config";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    base16-schemes = {
      url = "github:RisGar/base16-schemes";
      flake = false;
    };
    nix-colors = {
      url = "github:misterio77/nix-colors";
      inputs.base16-schemes.follows = "base16-schemes";
    };
    nix-rosetta-builder = {
      url = "github:cpick/nix-rosetta-builder";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
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
}

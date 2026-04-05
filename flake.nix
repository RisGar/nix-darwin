{
  description = "nix-darwin and nixos system flake";

  outputs =
    {
      homebrew-cask,
      homebrew-core,
      agenix,
      direnv-instant,
      disko,
      home-manager,
      mlpreview,
      nix-colors,
      nix-darwin,
      nix-homebrew,
      nix-index-database,
      nixln-edit,
      nixpkgs,
      nvim-config,
      self,
      virby,
      nix-openclaw,
      ocrtool-mcp,
      ...
    }:
    let
      inherit (nixpkgs) lib;
      secrets = import ./secrets lib;
    in
    {
      # Build darwin flake using:
      # $ sudo -i darwin-rebuild build --flake .#Rishabs-MacBook-Pro
      darwinConfigurations."Rishabs-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        modules = [
          virby.darwinModules.default
          home-manager.darwinModules.default
          nix-homebrew.darwinModules.default
          agenix.darwinModules.default

          ./hosts/macbook

          {
            age.secrets = secrets;

            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users."rishab" = ./home/rishab;
              backupFileExtension = "bak";

              extraSpecialArgs = {
                inherit
                  agenix
                  direnv-instant
                  nix-colors
                  nix-index-database
                  nvim-config
                  ocrtool-mcp
                  secrets
                  ;
              };
            };

            nix-homebrew = {
              enable = true;
              enableRosetta = false;
              user = "rishab";
              autoMigrate = true;
              # Declarative tap management
              taps = {
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
              };
              # mutableTaps = true;
            };
          }

        ];
        specialArgs = {
          inherit
            agenix
            mlpreview
            self
            nixln-edit
            ;
        };
      };

      nixosConfigurations."Rishabs-Homelab" = lib.nixosSystem {
        modules = [
          disko.nixosModules.default
          agenix.nixosModules.default
          nix-openclaw.nixosModules.openclaw-gateway

          ./hosts/homelab

          {
            age.secrets = secrets;
          }
        ];
        specialArgs = {
          # inherit nix-openclaw;
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
      inputs.nixpkgs.follows = "nixpkgs";
    };
    base16-schemes = {
      url = "github:RisGar/base16-schemes";
      flake = false;
    };
    nix-colors = {
      url = "github:misterio77/nix-colors";
      inputs.base16-schemes.follows = "base16-schemes";
    };
    virby = {
      url = "github:quinneden/virby-nix-darwin/be170bd7ef21ce9773e7daa646d43f5405a1bdb2";
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
    direnv-instant = {
      url = "github:Mic92/direnv-instant";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-openclaw = {
      url = "github:openclaw/nix-openclaw";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ocrtool-mcp = {
      url = "github:RisGar/ocrtool-mcp";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Homebrew taps
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };
}

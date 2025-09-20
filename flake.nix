{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    mlpreview.url = "github:RisGar/mlpreview";
    mlpreview.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs =
    inputs@{
      self,
      nix-darwin,
      home-manager,
      mlpreview,
      ...
    }:
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#Rishabs-MacBook-Pro
      darwinConfigurations."Rishabs-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        modules = [
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

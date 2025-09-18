{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs =
    inputs@{
      self,
      nix-darwin,
      home-manager,
      nixpkgs,
      ...
    }:
    let
      configuration =
        { pkgs, ... }:
        {
          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#Rishabs-MacBook-Pro
      darwinConfigurations."Rishabs-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          ./modules/system.nix
          ./modules/apps.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."rishab" = ./home;
            home-manager.backupFileExtension = "bak";

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
        specialArgs = { inherit inputs; };
      };
    };
}

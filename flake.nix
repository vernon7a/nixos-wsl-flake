{
  description = "Vale's simple NixOS & WSL configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs @ { nixpkgs, nixos-wsl, home-manager, flake-utils, nix-index-database, ... }:
    let
      home-manager-vernon7a = path: {
        home-manager = {
          useUserPackages = true;
          useGlobalPkgs = true;
          users.vernon7a = path;
          sharedModules = [
            nix-index-database.hmModules.nix-index
          ];
          extraSpecialArgs = {
            inherit inputs;
          };
        };
      };
    in
    {
      nixosConfigurations = {
        nixos-wsl = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            home-manager.nixosModules.default
            nixos-wsl.nixosModules.default
            (home-manager-vernon7a ./home.nix)
            ./wsl-host.nix
            nix-index-database.nixosModules.nix-index
          ];
          specialArgs = {
            inherit inputs;
            fetch = "disfetch";
          };
        };
      };
    };
}

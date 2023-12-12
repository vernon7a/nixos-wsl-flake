{
  description = "Vale's simple NixOS & WSL configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # I use tealdeer as a quick reference for some commands, but I want the
    # tldr page cache to be managed by my Nix setup instead.
    tldr-pages = {
      url = "github:tldr-pages/tldr";
      flake = false;
    };

  };

  outputs = inputs @ {
    nixpkgs,
    nixos-wsl,
    home-manager,
    flake-utils,
    nix-index-database,
    ...
  }: let
    # This defines the home-manager config module for a user called vernon7a.
    # My config structure assumes that this is the only user I'll want to set
    # up, but I'll have to rethink this one day.
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

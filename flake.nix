{
  description = "sdedovic/dotfiles";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    flake-utils,
    nixpkgs,
    home-manager,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
      };
    in {
      formatter = pkgs.alejandra;
      packages.homeConfigurations = {
        stevan = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./modules/devtools.nix
            {
              home.username = "stevan";
              home.homeDirectory = "/home/stevan";
              home.stateVersion = "23.05"; # Please read the comment before changing.
            }
          ];
        };
      };
    })
    // {
      homeManagerModules = {
        devtools = {...}: {
          imports = [./modules/devtools.nix];
        };
      };
    };
}

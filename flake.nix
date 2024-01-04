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
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      formatter = pkgs.alejandra;
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          home-manager.packages.${system}.home-manager
        ];
      };
    })
    // (let
      homeManagerSetup = { 
        username,
        homeDirectory ? "/home/${username}",
        system ? "x86_64-linux",
        isNixOS ? false,
      } : (
        let
          specialArgs = inputs // { inherit isNixOS; };
        in
          home-manager.lib.homeManagerConfiguration {
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
            modules = [
              ./modules/devtools.nix
              {
                home.devtools.enable = true;
                home.stateVersion = "23.11";
                home.username = username;
                home.homeDirectory = homeDirectory;
              }
            ];
            extraSpecialArgs = specialArgs;
          }
      );
    in {
      homeConfigurations = {
        stevan-wsl = homeManagerSetup { username = "root"; homeDirectory = "/root"; };
        stevan-mac = homeManagerSetup { 
          username = "stevan"; 
          homeDirectory = "/Users/stevan"; 
          system = "x86_64-darwin";
        };
      };
      homeManagerModules = {
        devtools = {...}: {
          imports = [./modules/devtools.nix];
        };
      };
    });
}

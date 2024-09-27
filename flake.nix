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

  outputs =
    inputs@{
      self,
      flake-utils,
      nixpkgs,
      home-manager,
    }:
    let
      overlays = import ./overlays;
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        formatter = pkgs.nixfmt-rfc-style;
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [ home-manager.packages.${system}.home-manager ];
        };
      }
    )
    // flake-utils.lib.meld inputs [
      ./overlays
      ./modules
      ./systems
      ./pkgs
    ];
}

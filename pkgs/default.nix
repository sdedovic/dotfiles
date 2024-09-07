{
  self,
  nixpkgs,
  flake-utils,
  ...
}:
flake-utils.lib.eachDefaultSystem (
  system:
  let
    pkgs = import nixpkgs { inherit system; };
  in
  {
    packages.argc = pkgs.callPackage ./argc { };

    packages.ci-tool = pkgs.callPackage ./ci-tool { };
  }
)

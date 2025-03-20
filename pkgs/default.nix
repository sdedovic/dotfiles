{
  self,
  nixpkgs,
  flake-utils,
  ...
}:
flake-utils.lib.eachDefaultSystem (
  system: let
    pkgs = import nixpkgs {
      inherit system;
      overlays = [self.overlays.default];
      config.allowUnfree = true;
    };
  in {
    packages.argc = pkgs.argc;
    packages.ci-tool = pkgs.ci-tool;
    packages.bws = pkgs.bws;
    packages.tsx = pkgs.tsx;
  }
)

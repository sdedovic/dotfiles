{
  self,
  flake-utils,
  nixpkgs,
  ...
}: {
  overlays.customPackages = final: prev: {
    argc = final.callPackage ../pkgs/argc {};
    ci-tool = final.callPackage ../pkgs/ci-tool {};
    bws = final.callPackage ../pkgs/bws {};
    tsx = final.callPackage ../pkgs/tsx {};
  };

  overlays.default = nixpkgs.lib.composeManyExtensions [self.overlays.customPackages];

  nixosModules.defaultOverlay = {
    nixpkgs = {
      overlays = [self.overlays.default];
    };
  };
}

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
    python-kacl = final.callPackage ../pkgs/python-kacl {};
  };

  overlays.default = nixpkgs.lib.composeManyExtensions [self.overlays.customPackages];

  nixosModules.defaultOverlay = {
    nixpkgs = {
      overlays = [self.overlays.default];
    };
  };
}

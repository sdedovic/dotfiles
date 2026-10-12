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

    scorecard = prev.scorecard.overrideAttrs (_: {
      vendorHash = "sha256-0KKKZheDNRPLBWtwXgXXG+ixpESO+Gq1FsW83PldiVo=";
    });
  };

  overlays.default = nixpkgs.lib.composeManyExtensions [self.overlays.customPackages];

  nixosModules.defaultOverlay = {
    nixpkgs = {
      overlays = [self.overlays.default];
    };
  };
}

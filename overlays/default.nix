let
  newPackages = final: prev: {
    argc = final.callPackage ../pkgs/argc {};
    ci-tool = final.callPackage ../pkgs/ci-tool {};
  };
in
  [newPackages]

inputs @ {
  self,
  flake-utils,
  nixpkgs,
  home-manager,
  ...
}: let
  homeManagerSetup = import ../lib/homeSetup.nix {
    inherit nixpkgs home-manager;
    defaultOverlays = [self.overlays.customPackages];
  };
in {
  homeConfigurations = {
    stevan-wsl = homeManagerSetup {
      username = "root";
      homeDirectory = "/root";
      modules = [
        self.homeManagerModules.desktop
        {home.devtools.highDPI = true;}
      ];
    };
    stevan-mac = homeManagerSetup {
      username = "stevan";
      homeDirectory = "/Users/stevan";
      system = "x86_64-darwin";
      modules = [
        self.homeManagerModules.desktop
        {home.devtools.highDPI = true;}
      ];
    };
    stevan-mac-m3 = homeManagerSetup {
      username = "stevan";
      homeDirectory = "/Users/stevan";
      system = "aarch64-darwin";
      modules = [
        self.homeManagerModules.desktop
        { home.devtools.highDPI = true; }
      ];
    };
    stevan = homeManagerSetup {
      username = "stevan";
      isNixOS = true;
      modules = [
        self.homeManagerModules.desktop
        {home.devtools.highDPI = true;}
      ];
    };
  };
}

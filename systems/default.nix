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
      username = "stevan";
      modules = [
        self.homeManagerModules.desktop
        {
          imports = [../mixins/mpd.nix];
          home = {
            music.mpd = {
              enable = true;
              musicDirectory = "/mnt/z/Music";
              audioOutput = "pulse";
              wslBullshit = true;
            };
            devtools.highDPI = true;
          };
          programs.zsh = {
            sessionVariables = {
              WAYLAND_DISPLAY = "wayland-0";
              DISPLAY = ":0";
            };
            initContent = ''
              # auto-mount Z: drive because wsl kinda sucks at this stuff
              if ! mountpoint -q /mnt/z; then
                sudo mkdir -p /mnt/z 2>/dev/null
                sudo mount -t drvfs 'Z:' /mnt/z 2>/dev/null || true
              fi
            '';
          };
        }
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
        {home.devtools.highDPI = true;}
      ];
    };
    stevan-mac-work = homeManagerSetup {
      username = "stevan";
      homeDirectory = "/Users/stevan";
      system = "aarch64-darwin";
      modules = [
        self.homeManagerModules.work
        {
          home.devtools.highDPI = true;
          home.devtools.git.userEmail = "stevan@rectanglehq.com";
        }
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

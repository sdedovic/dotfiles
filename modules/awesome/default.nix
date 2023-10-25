{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.home.awesome;
in {
  options.home.awesome.enable = lib.mkEnableOption "awesome";
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      mpc-cli
      rofi
      flameshot
    ];

    xsession = {
      enable = true;
      windowManager.awesome.enable = true;
    };

    services.picom = {
      enable = true;
      backend = "glx";
      vSync = true; # may help with performance
      extraArgs = [
        "--blur-method=dual_kawase"
        "--blur-strength=3"
      ];
    };

    programs.alacritty = {
      enable = true;
      settings = {
        window.opacity = 0.8;
        font = {
          size = 12;
        };
      };
    };

    #  services.xscreensaver = {
    #    enable = true;
    #  };
    home.file.".xscreensaver".source = ./.xscreensaver;

    home.file.".config/awesome/rc.lua".source = ./rc.lua;
  };
}

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
      fadeDelta = 2;
      backend = "glx";
      activeOpacity = 0.8;
      extraArgs = [
        "--blur-method=dual_kawase"
        "--blur-strength=3"
      ];
    };

    programs.alacritty = {
      enable = true;
      settings = {
        window.opacity = 0.0;
        font = {
          size = 9.5;
        };
      };
    };

    home.file.".config/awesome/rc.lua".source = ./rc.lua;
  };
}

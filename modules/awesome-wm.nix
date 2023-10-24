{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.home.awesome-wm;
in {
  options.home.awesome-wm.enable = lib.mkEnableOption "awesome-wm";
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      mpc
      rofi
      flameshot
    ];

    xsession = {
      enable = true;
      windowManager.awesome.enable = true;
    };

    home.file.".config/awesome/rc.lua".source = ./awesome/rc.lua;
  };
}

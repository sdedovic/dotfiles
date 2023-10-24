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
      mpc-cli
      rofi
      flameshot
    ];

    xsession = {
      enable = true;
      windowManager.awesome.enable = true;
      scriptPath = ".hm-xsession";
    };

    home.file.".config/awesome/rc.lua".source = ./awesome/rc.lua;
  };
}

{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.home.devtools;
in {
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      wtf
    ];

    home.file.".config/wtf/config.yml".source = ./config.yml;
  };
}

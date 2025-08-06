{
  pkgs,
  config,
  lib,
  ...
}: {
  home.packages = with pkgs; [wtfutil];

  home.file.".config/wtf/config.yml".source = ./config.yml;
}

{
  pkgs,
  config,
  lib,
  ...
}:
{
  home.packages = with pkgs; [ wtf ];

  home.file.".config/wtf/config.yml".source = ./config.yml;
}

{
  pkgs,
  config,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    python312
    # node.pkgs.pyright
  ];
}

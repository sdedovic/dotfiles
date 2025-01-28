{ pkgs, ... }:
{
  home.packages = with pkgs; [ trufflehog ];
}

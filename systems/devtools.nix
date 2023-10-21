{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.home.devtools;
in {
  options.home.devtools.enable = lib.mkEnableOption "devtools";
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      neovim
      alacritty
      tmux
      ripgrep
      direnv
      jq
    ];
  };
}

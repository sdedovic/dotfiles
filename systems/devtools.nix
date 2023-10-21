{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.dotfiles.devtools;
in {
  imports = [];
  options = {
    enable = lib.mkEnableOption "devtools";
  };
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

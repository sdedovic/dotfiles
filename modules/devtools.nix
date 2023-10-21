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
      ripgrep
      tmux
      neovim
      alacritty
      jq
    ];

    home.file.".tmux.conf".source = ./.tmux.conf;

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    home.file.".direnvrc".source = ./.direnvrc;
  };
}

{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.home.devtools;
in {
  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    home.file.".direnvrc".source = ./.direnvrc;

    programs.zsh.oh-my-zsh.plugins = ["direnv"];
  };
}

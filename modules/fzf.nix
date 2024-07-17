{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.home.devtools;
in {
  config = lib.mkIf cfg.enable {
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.zsh.oh-my-zsh.plugins = ["fzf"];
  };
}

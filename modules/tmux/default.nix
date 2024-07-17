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
      tmux
    ];

    programs.zsh = {
      shellAliases = {
        ta = "tmux attach";
        ts = "tmux new -s";
        tx = "tmux resize-pane -x";
        ty = "tmux resize-pane -y";
      };

      initExtra = ''
        if [[ -n "$DISPLAY" && -z "$TMUX" ]];
        then
          exec tmux new-session;
        fi
      '';
    };

    home.file.".tmux.conf".source = ./.tmux.conf;
  };
}

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

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      shellAliases = {
        ta = "tmux attach";
        ts = "tmux new -s";
        tx = "tmux resize-pane -x";
        ty = "tmux resize-pane -y";
      };
      oh-my-zsh = {
        enable = true;
        plugins = ["colored-man-pages" "direnv" "extract" "fzf" "git" "systemd" "sudo" "themes" "z"];
        theme = "robbyrussell";
      };
      syntaxHighlighting.enable = true;
      initExtra = ''
        if [[ -n "$DISPLAY" && -z "$TMUX" ]];
        then
          exec tmux new-session;
        fi
      '';
    };

    home.file.".tmux.conf".source = ./.tmux.conf;

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    home.file.".direnvrc".source = ./.direnvrc;
  };
}

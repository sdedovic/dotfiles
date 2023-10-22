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
        # direnv python
        setopt PROMPT_SUBST
        show_virtual_env() {
          if [[ -n "$VIRTUAL_ENV" && -n "$DIRENV_DIR" ]]; then
              echo "($(basename $VIRTUAL_ENV))"
          fi
        }
        PS1='$(show_virtual_env)'$PS1

        # sdkman
        export SDKMAN_DIR="${HOME}/.sdkman"
        [[ -s "${HOME}/.sdkman/bin/sdkman-init.sh" ]] && source "${HOME}/.sdkman/bin/sdkman-init.sh"

        # nvim
        export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

        # rvim
        export PATH="$PATH:$HOME/.rvm/bin"

        # cargo
        if [ -e $HOME/.cargo/bin ] && [ -d $HOME/.cargo/bin ]; then export PATH=$HOME/.cargo/bin:$PATH; fi


        # prompt stuff
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

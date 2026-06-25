{
  pkgs,
  config,
  lib,
  ...
}: {
  programs.tmux = {
    enable = true;

    sensibleOnTop = true;

    shortcut = "C-a";
    terminal = "screen-256color";
    baseIndex = 1;
    keyMode = "vi";
    aggressiveResize = true;
    escapeTime = 0;
    customPaneNavigationAndResize = true;
    reverseSplit = true;

    extraConfig = ''
      bind : command-prompt

      # vim-like copy/paste
      bind-key C-p run "@pasteCommand@ | tmux load-buffer - ; tmux paste-buffer"
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel "@copyCommand@"
      bind-key -T copy-mode-vi Enter send -X cancel

      set -g set-titles on
      set -g set-titles-string "#T"

      # status bar
      set -g status-bg black
      set -g status-fg white
      set -g status-right "#[fg=green]#H"

      # highlight active window
      set-window-option -g window-status-current-style bg=red

      # urxvt tab-like window switching
      bind -n S-down new-window
      bind -n S-left prev
      bind -n S-right next
      bind -n C-left swap-window -t -1
      bind -n C-right swap-window -t +1

      # unbind things that I screw up often
      unbind C-j
      unbind C-z

      unbind r
      bind r source-file ${config.xdg.configHome}/tmux/tmux.conf
    '';

    plugins = with pkgs.tmuxPlugins; [
      resurrect

      # https://github.com/nix-community/home-manager/issues/9558
      # https://github.com/nix-community/home-manager/issues/3555
      # {
      #   plugin = continuum;
      #   extraConfig = ''
      #     set -g @continuum-restore 'on'
      #     set -g @continuum-boot 'on'
      #     set -g @continuum-boot-options 'alacritty'
      #   '';
      # }
    ];
  };

  programs.zsh = {
    shellAliases = {
      ta = "tmux attach";
      ts = "tmux new -s";
      tx = "tmux resize-pane -x";
      ty = "tmux resize-pane -y";
    };

    initContent = ''
      if [[ -n "$DISPLAY" && -z "$TMUX" ]];
      then
        exec tmux new-session;
      fi
    '';
  };
}

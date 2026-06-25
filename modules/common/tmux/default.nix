{
  pkgs,
  config,
  lib,
  ...
}: {
  #home.packages = with pkgs; [tmux];
  programs.tmux = {
    enable = true;

    shortcut = "C-a";
    terminal = "screen-256color";
    baseIndex = 1;
    keyMode = "vi";
    aggressiveResize = true;
    escapeTime = 0;
    customPaneNavigationAndResize = true;
    reverseSplit = true;

    extraConfig = let
      configFile = builtins.readFile ./.tmux.conf;
    in ''
      ${configFile}

      # home-manager install in XDG Config Home whereas I installed
      #  ~/.tmux.conf. So this lets me reload from the new place.
      unbind r
      bind r source-file ${config.xdg.configHome}/tmux/tmux.conf

      # continuum
      set -g @continuum-restore 'on'
    '';

    plugins = with pkgs.tmuxPlugins; [
      continuum
    ];
  };
  #home.file.".tmux.conf".source = ./.tmux.conf;

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

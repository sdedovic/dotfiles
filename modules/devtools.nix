{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.home.devtools;
in {
  imports = [
    ./alacritty.nix
    ./git.nix
    ./nix.nix
    ./nvim.nix
  ];
  options.home.devtools.enable = lib.mkEnableOption "devtools";
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      ripgrep
      tmux
      jq
      bws
      htop
      tree
      stow

      zip
      unzip
      p7zip
      unrar

      ci-tool
    ];

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      history.share = false;
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
      initExtra = let
        dl-mp4 = builtins.readFile ./dl-mp4.sh;
      in ''
        ${dl-mp4}

        if [[ -n "$DISPLAY" && -z "$TMUX" ]];
        then
          exec tmux new-session;
        fi

        # robbyrussell theme but overrides to add hostname
        PROMPT="%{$fg[red]%}[%m]%{$reset_color%}"
        PROMPT+="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ ) %{$fg[cyan]%}%c%{$reset_color%}"
        PROMPT+=' $(git_prompt_info)'
      '';
    };

    home.file.".tmux.conf".source = ./.tmux.conf;

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    home.file.".direnvrc".source = ./.direnvrc;

    home.file.".lein/profiles.clj".text = ''
      {:user {:plugins [[cider/cider-nrepl "0.44.0"]]}}
    '';
  };
}

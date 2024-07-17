{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.home.devtools;
in {
  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      history.share = false;
      oh-my-zsh = {
        enable = true;
        plugins = ["colored-man-pages" "extract" "systemd" "sudo" "themes" "z"];
        theme = "robbyrussell";
      };
      syntaxHighlighting.enable = true;
      initExtra = let
        dl-mp4 = builtins.readFile ./dl-mp4.sh;
      in ''
        ${dl-mp4}

        # robbyrussell theme but overrides to add hostname
        PROMPT="%{$fg[red]%}[%m]%{$reset_color%}"
        PROMPT+="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ ) %{$fg[cyan]%}%c%{$reset_color%}"
        PROMPT+=' $(git_prompt_info)'
      '';
    };
  };
}

{
  pkgs,
  config,
  lib,
  ...
}:
{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh.oh-my-zsh.plugins = [ "fzf" ];
}

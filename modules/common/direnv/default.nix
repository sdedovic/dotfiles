{
  pkgs,
  config,
  lib,
  ...
}:
{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.file.".direnvrc".source = ./.direnvrc;

  programs.zsh.oh-my-zsh.plugins = [ "direnv" ];
}

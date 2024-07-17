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
    ./direnv
    ./git.nix
    ./fzf.nix
    ./languages.nix
    ./nix.nix
    ./nvim.nix
    ./tmux
    ./zsh
  ];

  options.home.devtools.enable = lib.mkEnableOption "devtools";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # general system utilities
      ripgrep
      jq
      htop
      stow

      # secrets management
      bws

      # file system management
      ranger
      tree

      # encoding / decoding
      ffmpeg_7-headless

      # archives
      zip
      unzip
      p7zip
      unrar

      # my stuff
      ci-tool
    ];
  };
}

{ pkgs, ... }:
{
  imports = [
    ./direnv
    ./tmux
    ./zsh
    ./fzf.nix
    ./git.nix
    ./languages.nix
    ./nix.nix
    ./nvim.nix
  ];

  config = {
    home.packages = with pkgs; [
      # general system utilities
      ripgrep
      jq
      htop
      mdcat

      # secrets management
      bws

      # file system management
      ranger
      tree

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

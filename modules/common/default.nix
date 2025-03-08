{pkgs, ...}: {
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
    # TODO(2025-01-22): move to own file / dir
    programs.zellij = {
      # enable = true;

      # not sure if still supported and
      #  this will add some zsh init stuff I dont want yet
      #
      # enableZshIntegration = true;
    };

    home.packages = with pkgs; [
      # general system utilities
      ripgrep
      jq
      htop
      mdcat

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
    ] ++ pkgs.lib.optionals (!pkgs.stdenv.hostPlatform.isDarwin) [
      # secrets management
      bws
    ];
  };
}

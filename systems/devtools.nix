{pkgs, ...}: {
  home.packages = with pkgs; [
    neovim
    alacritty
    tmux
    ripgrep
    direnv
    jq
  ];
}

{
  pkgs,
  config,
  lib,
  ...
}:
{
  # terraform plus all these plugins makes neovim a little too heavy for my liking
  programs.neovim = {
    extraPackages = with pkgs; [ terraform ];
    plugins = with pkgs.vimPlugins; [
      vim-javascript
      vim-jsx-pretty
      vim-fireplace
      vim-nix
      vim-terraform
      vim-glsl
    ];
  };
}

{ ... }:
{
  imports = [
    ../common

    ./alacritty.nix
    ./kubernetes.nix
    ./languages.nix
    ./media.nix
    ./nvim.nix
    ./security.nix
    ./wtf
  ];
}

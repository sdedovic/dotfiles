{ pkgs, lib, ... }:
{
  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      connect-timeout = lib.mkDefault 5;
      log-lines = lib.mkDefault 25;
    };
  };

  nixpkgs.config.allowUnfree = true;
  xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";
}

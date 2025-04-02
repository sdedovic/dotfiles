{
  pkgs,
  lib,
  config,
  ...
}: {
  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      trusted-users = ["stevan"];
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

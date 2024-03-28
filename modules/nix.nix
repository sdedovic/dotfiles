{pkgs, ...}: {
  nix = {
    package = pkgs.nix;
    settings.experimental-features = "nix-command flakes";
  };

  nixpkgs.config.allowUnfree = true;
  xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";
}

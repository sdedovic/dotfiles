{pkgs, ...}: {
  imports = [
    ../desktop
  ];

  home.packages = with pkgs; [kaf go-migrate];
}

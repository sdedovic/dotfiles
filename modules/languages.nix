{
  pkgs,
  config,
  lib,
  ...
}:
lib.mkMerge [
  # Clojure
  {
    home.packages = with pkgs; [
      leiningen
      temurin-bin-21
    ];

    home.file.".lein/profiles.clj".text = ''
      {:user {:plugins [[cider/cider-nrepl "0.44.0"]]}}
    '';
  }

  # Julia
  {
    home.packages = with pkgs; [
      (julia-bin.overrideAttrs
      (final: prev: {doCheck = false;}))
    ];
  }
]

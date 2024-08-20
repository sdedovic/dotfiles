{
  pkgs,
  config,
  lib,
  isNixOS ? false,
  ...
}:
lib.mkMerge [
  # Python
  {
    home.packages = with pkgs; [
      python312
      nodePackages.pyright
    ];
  }

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
        (final: prev: {doInstallCheck = false;}))
    ];
  }

  # externally managed Rust
  (lib.mkIf (! isNixOS) {
    programs.zsh.envExtra = ''
      . "$HOME/.cargo/env"
    '';
  })

  {
    programs.zsh.envExtra = ''
      PATH=$PATH:$HOME/.cargo/bin/
    '';
  }

  # Javascript / Typescript
  {
    home.packages = with pkgs; [
      nodejs_20
      nodePackages.typescript-language-server
    ];
  }
]

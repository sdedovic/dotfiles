{
  pkgs,
  config,
  lib,
  isNixOS ? false,
  ...
}: let
  node = pkgs.nodejs_22;
in
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
      home.packages = with pkgs; [(julia-bin.overrideAttrs (final: prev: {doInstallCheck = false;}))];
    }

    # externally managed Rust
    (lib.mkIf (!isNixOS) {
      programs.zsh.envExtra = ''
        [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
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
        node
        node.pkgs.typescript-language-server
        tsx
      ];
      home.file.".npmrc".text = ''
        min-release-age=7 # days
        ignore-scripts=true
      '';
    }

    # Go
    {
      home.packages = with pkgs; [
        go
      ];
    }
  ]

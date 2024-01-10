{
  pkgs,
  config,
  lib,
  isNixOS ? false,
  ...
}: let
  cfg = config.home.devtools;
in {
  options.home.devtools.highDPI = lib.mkEnableOption "high DPI display support";
  config = lib.mkIf cfg.enable (
    let
      settings = {
        window.opacity = 0.9;
        font = {
          size =
            if cfg.highDPI
            then 14.5
            else 9.5;
        };
      };
    in {
      programs.alacritty = lib.mkIf isNixOS {
        enable = true;
        inherit settings;
      };

      xdg.configFile."alacritty/alacritty.toml" = lib.mkIf (! isNixOS) (let
        tomlFormat = pkgs.formats.toml {};
        inherit settings;
      in {
        source =
          (tomlFormat.generate "alacritty.toml" settings).overrideAttrs
          (finalAttrs: prevAttrs: {
            buildCommand = lib.concatStringsSep "\n" [
              prevAttrs.buildCommand
              # TODO: why is this needed? Is there a better way to retain escape sequences?
              "substituteInPlace $out --replace '\\\\' '\\'"
            ];
          });
      });
    }
  );
}

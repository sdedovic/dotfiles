{
  pkgs,
  config,
  lib,
  isNixOS ? false,
  ...
}:
let
  cfg = config.home.devtools;
in
{
  options.home.devtools.highDPI = lib.mkEnableOption "high DPI display support";

  config =
    let
      settings = {
        window.opacity = 0.8;
        font = {
          size = if cfg.highDPI then 17 else 12;
        };
      };
    in
    {
      programs.alacritty = lib.mkIf isNixOS {
        enable = true;
        inherit settings;
      };

      xdg.configFile."alacritty/alacritty.toml" = lib.mkIf (!isNixOS) (
        let
          tomlFormat = pkgs.formats.toml { };
          inherit settings;
        in
        {
          source = (tomlFormat.generate "alacritty.toml" settings).overrideAttrs (
            finalAttrs: prevAttrs: {
              buildCommand = lib.concatStringsSep "\n" [
                prevAttrs.buildCommand
                # TODO: why is this needed? Is there a better way to retain escape sequences?
                "substituteInPlace $out --replace '\\\\' '\\'"
              ];
            }
          );
        }
      );
    };
}

{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.home.devtools;
in {
  imports = [
    ./nvim.nix
  ];
  options.home.devtools.git = with lib; {
    userName = lib.mkOption {
      default = "sdedovic";
      example = "stevan";
      description = "Default user name to use.";
      type = types.nullOr types.str;
    };
    userEmail = lib.mkOption {
      default = "stevan@dedovic.com";
      example = "foo@email.com";
      description = "Default user email to use.";
      type = types.nullOr types.str;
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      git
    ];

    programs.git = {
      inherit (cfg.git) userName userEmail;
      enable = true;
    };
  };
}

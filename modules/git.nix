{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.home.devtools;
  git = pkgs.gitFull;
in {
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
    home.packages = [git];

    programs.git = {
      inherit (cfg.git) userName userEmail;
      enable = true;
      package = git;

      extraConfig.credential.helper = "cache --timeout=3600";
      lfs.enable = true;
      difftastic.enable = true;

      aliases = let
        fzf = config.programs.fzf.package;
      in {
        # shows a list of modified/new files in fzf, selection will git-add
        fza = "!${git}/bin/git ls-files -m -o --exclude-standard | ${fzf}/bin/fzf -m --print0 | xargs -0 git add";

        # remove local branches that don't exist on remote
        gone = "!f() { ${git}/bin/git fetch --all --prune; ${git}/bin/git branch -vv | awk '/: gone]/{print $1}' | xargs git branch -D; }; f";

        # print out the root of the repo, may be used 'cd $(git root)'
        root = "rev-parse --show-toplevel";
      };
    };
  };
}

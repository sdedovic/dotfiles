{
  pkgs,
  config,
  lib,
  isNixOS ? false,
  ...
}: let
  cfg = config.home.devtools;
  git = pkgs.git.override {withSsh = true;};
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
  config = {
    home.packages = [
      git
      pkgs.bfg-repo-cleaner
    ];

    programs.git = {
      enable = true;
      package = git;

      lfs.enable = true;

      settings = {
        user.name = cfg.git.userName;
        user.email = cfg.git.userEmail;
        init.defaultBranch = "main";

        credential.helper = "cache --timeout=3600 --socket=$HOME/.git-credential-cache";

        alias = let
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
    programs.difftastic = {
      enable = true;
      git.enable = true;
    };
    programs.zsh.oh-my-zsh.plugins = ["git"];
  };
}

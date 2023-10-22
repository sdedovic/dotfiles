{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.home.devtools;
in {
  options.home.devtools.enable = lib.mkEnableOption "devtools";
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      ripgrep
      tmux
      neovim
      alacritty
      jq
    ];

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      plugins = with pkgs.vimPlugins; [
        # general
        nvim-lspconfig
        {
          plugin = which-key-nvim;
          type = "lua";
          config = "require('which-key').setup {}";
        }

        # telescope and friends
        plenary-nvim
        telescope-fzf-native-nvim
        telescope-ui-select-nvim
        telescope-nvim

        # language specific
        vim-javascript
        vim-jsx-pretty
        vim-fireplace
        vim-nix
        vim-terraform

        {
          plugin = none-ls-nvim;
          type = "lua";
          config = ''
            local null_ls = require('null-ls')
            null_ls.setup({
              on_attach = lsp_on_attach,
              sources = {
                null_ls.builtins.formatting.jq,
                null_ls.builtins.formatting.terraform_fmt,
                null_ls.builtins.formatting.alejandra,
              }
            })
          '';
        }
      ];
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      shellAliases = {
        ta = "tmux attach";
        ts = "tmux new -s";
        tx = "tmux resize-pane -x";
        ty = "tmux resize-pane -y";
      };
      oh-my-zsh = {
        enable = true;
        plugins = ["colored-man-pages" "direnv" "extract" "fzf" "git" "systemd" "sudo" "themes" "z"];
        theme = "robbyrussell";
      };
      syntaxHighlighting.enable = true;
      initExtra = ''
        if [[ -n "$DISPLAY" && -z "$TMUX" ]];
        then
          exec tmux new-session;
        fi
      '';
    };

    home.file.".tmux.conf".source = ./.tmux.conf;

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    home.file.".direnvrc".source = ./.direnvrc;
  };
}

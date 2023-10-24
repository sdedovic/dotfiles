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
      tmux
      alacritty
      jq
    ];

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      extraPackages = [pkgs.ripgrep];
      plugins = with pkgs.vimPlugins; [
        # lsp
        {
          plugin = nvim-lspconfig;
          type = "lua";
          config = ''
            local lsp_on_attach = function(_, bufnr)
              local opts = { noremap=true, silent=true }

              -- Format on save
              vim.api.nvim_command('autocmd BufWritePre <buffer> lua vim.lsp.buf.format({async=false})')

              -- Enable completion triggered by <c-x><c-o>
              vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

              vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', ':Telescope lsp_definitions theme=cursor<CR>', opts)
              vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', ':lua vim.diagnostic.goto_prev()<CR>', opts)
              vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', ':lua vim.diagnostic.goto_next()<CR>', opts)
              vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', ':lua vim.lsp.buf.hover()<CR>', opts)
              vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>ln', ':lua vim.lsp.buf.rename()<CR>', opts)
              vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>la', ':lua vim.lsp.buf.code_action()<CR>', opts)
              vim.api.nvim_buf_set_keymap(bufnr, 'v', '<Leader>la', ':lua vim.lsp.buf.range_code_action()<CR>', opts)
              vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>lr', ':Telescope lsp_references theme=cursor<CR>', opts)
              vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>ls', ':Telescope lsp_workspace_symbols<CR>', opts)
              vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>ld', ':Telescope diagnostics<CR>', opts)
              vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>lt', ':Telescope lsp_type_definitions<CR>', opts)
            end

            local lspconfig = require('lspconfig')
            local setup_config = {
              on_attach = lsp_on_attach,
              flags = {
                -- This will be the default in neovim 0.7+
                debounce_text_changes = 150,
              }
            }
            lspconfig.rust_analyzer.setup(setup_config)
            lspconfig.pyright.setup(setup_config)
            lspconfig.tsserver.setup(setup_config)
          '';
        }

        # misc
        {
          plugin = which-key-nvim;
          type = "lua";
          config = "require('which-key').setup {}";
        }

        # telescope and friends
        plenary-nvim
        telescope-fzf-native-nvim
        telescope-ui-select-nvim
        {
          plugin = telescope-nvim;
          type = "lua";
          config = ''
            local function noremap(mode, lhs, rhs)
              vim.api.nvim_set_keymap(mode, lhs, rhs, {noremap = true})
            end

            local telescope = require("telescope")
            local telescopeConfig = require("telescope.config")
            local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }
            table.insert(vimgrep_arguments, "--hidden")
            table.insert(vimgrep_arguments, "--glob")
            table.insert(vimgrep_arguments, "!**/.git/*")
            table.insert(vimgrep_arguments, "--glob")
            table.insert(vimgrep_arguments, "!**/package-lock.json")
            telescope.setup({
              defaults = {
                vimgrep_arguments = vimgrep_arguments,
              },
              pickers = {
                find_files = {
                  -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
                  find_command = { "${pkgs.ripgrep}/bin/rg", "--files", "--hidden", "--glob", "!**/.git/*" },
              	},
              },
              extensions = {
                ["ui-select"] = {
                  require("telescope.themes").get_cursor {}
                }
              }
            })
            telescope.load_extension('ui-select')
            noremap('n', '<Leader>f', ':Telescope find_files<CR>')
            noremap('n', '<Leader>b', ':Telescope buffers<CR>')
            noremap('n', '<Leader>o', ':Telescope oldfiles<CR>')
            noremap('n', '<Leader>g', ':Telescope live_grep<CR>')
            noremap('n', 'z=', ':Telescope spell_suggest<CR>')
          '';
        }

        # language specific
        vim-javascript
        vim-jsx-pretty
        vim-fireplace
        vim-nix
        vim-terraform

        # theme
        {
          plugin = papercolor-theme;
          type = "lua";
          config = ''
            vim.o.termguicolors = true
            vim.o.background = 'dark'
            vim.cmd [[
              colorscheme PaperColor
              hi! Normal ctermbg=NONE guibg=NONE
              hi! NonText ctermbg=NONE guibg=NONE
            ]]
          '';
        }

        # LSP-ish
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

      extraLuaConfig = ''
        local function noremap(mode, lhs, rhs)
          vim.api.nvim_set_keymap(mode, lhs, rhs, {noremap = true})
        end

        -- mappings
        vim.g.mapleader = ' '
        noremap('n', '<Leader>e', ':Explore<CR>')
        noremap('n', '<Leader>w', ':update<CR>')
        -- window navigation
        noremap('n', '<C-h>', '<C-w><C-h>')
        noremap('n', '<C-j>', '<C-w><C-j>')
        noremap('n', '<C-k>', '<C-w><C-k>')
        noremap('n', '<C-l>', '<C-w><C-l>')

        -- basics
        vim.o.breakindent = true
        vim.o.completeopt = 'menuone'
        vim.o.cursorline = true
        vim.o.expandtab = true
        vim.o.ignorecase = true
        vim.o.linebreak = true
        vim.o.number = true
        vim.o.shiftwidth = 2
        vim.o.smartcase = true
        vim.o.softtabstop = 2
        vim.o.tabstop = 2
        vim.o.undofile = true
        vim.o.wildmode = 'longest:full,full'
        vim.o.showmatch = true
        vim.o.wrap = false
      '';
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

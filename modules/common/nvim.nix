{
  pkgs,
  config,
  lib,
  ...
}:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      alejandra
      ripgrep
      jq
      python3
      yamlfmt
    ];
    plugins = with pkgs.vimPlugins; [
      # lsp
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = ''
          local lsp_on_attach = function(_, bufnr)
            local opts = { buffer = true, silent = true }

            -- Format on save
            vim.api.nvim_command('autocmd BufWritePre <buffer> lua vim.lsp.buf.format({async=false})')

            -- Enable completion triggered by <c-x><c-o>
            vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

            vim.keymap.set('n', 'gd', ':Telescope lsp_definitions theme=cursor<CR>', opts)
            vim.keymap.set('n', '[d', ':lua vim.diagnostic.goto_prev()<CR>', opts)
            vim.keymap.set('n', ']d', ':lua vim.diagnostic.goto_next()<CR>', opts)
            vim.keymap.set('n', 'K', ':lua vim.lsp.buf.hover()<CR>', opts)
            vim.keymap.set('n', '<Leader>ln', ':lua vim.lsp.buf.rename()<CR>', opts)
            vim.keymap.set('n', '<Leader>la', ':lua vim.lsp.buf.code_action()<CR>', opts)
            vim.keymap.set('n', '<Leader>li', ':lua vim.diagnostic.open_float()<CR>', opts)
            vim.keymap.set('v', '<Leader>la', ':lua vim.lsp.buf.range_code_action()<CR>', opts)
            vim.keymap.set('n', '<Leader>lr', ':Telescope lsp_references theme=cursor<CR>', opts)
            vim.keymap.set('n', '<Leader>ls', ':Telescope lsp_workspace_symbols<CR>', opts)
            vim.keymap.set('n', '<Leader>ld', ':Telescope diagnostics<CR>', opts)
            vim.keymap.set('n', '<Leader>lt', ':Telescope lsp_type_definitions<CR>', opts)
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
          lspconfig.ts_ls.setup(setup_config)
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
          vim.keymap.set('n', '<Leader>f', ':Telescope find_files<CR>')
          vim.keymap.set('n', '<Leader>b', ':Telescope buffers<CR>')
          vim.keymap.set('n', '<Leader>o', ':Telescope oldfiles<CR>')
          vim.keymap.set('n', '<Leader>g', ':Telescope live_grep<CR>')
          vim.keymap.set('n', 'z=', ':Telescope spell_suggest<CR>')
        '';
      }

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
            debug = true,
            on_attach = lsp_on_attach,
            sources = {
              null_ls.builtins.formatting.jq,
              null_ls.builtins.formatting.terraform_fmt,
              null_ls.builtins.formatting.alejandra,
              null_ls.builtins.formatting.yamlfmt,
            }
          })
        '';
      }

      {
        plugin = zen-mode-nvim;
        type = "lua";
        config = ''
          require("zen-mode").setup({
            window = {
              width = 90,
            },
          })
          vim.keymap.set("n", "<leader>zz", ":ZenMode<CR>")
        '';
      }
    ];

    extraLuaConfig = ''
      -- mappings
      vim.g.mapleader = ' '
      vim.keymap.set('n', '<Leader>e', ':Explore<CR>')
      vim.keymap.set('n', '<Leader>w', ':update<CR>')

      -- window navigation
      vim.keymap.set('n', '<C-h>', '<C-w><C-h>')
      vim.keymap.set('n', '<C-j>', '<C-w><C-j>')
      vim.keymap.set('n', '<C-k>', '<C-w><C-k>')
      vim.keymap.set('n', '<C-l>', '<C-w><C-l>')

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
      vim.o.backupcopy = 'yes'

      -- better compl-filename
      vim.api.nvim_create_autocmd('InsertLeave', {
        group = vim.api.nvim_create_augroup('RelativeFileAutocomplete', { clear = true }),
        pattern = { '*' },
        callback = function()
          if vim.w.relative_file_autocomplete_cleanup then
            vim.cmd.lcd('-')
            vim.w.relative_file_autocomplete_cleanup = false
          end
        end
      })
      function enter_relative_file_autocomplete()
        vim.w.relative_file_autocomplete_cleanup = true
        vim.cmd.lcd('%:p:h')
      end
      vim.keymap.set('i', '<C-x><C-x><C-f>', '<C-o><cmd> lua enter_relative_file_autocomplete()<CR><C-x><C-f>')

      -- per-language
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { '*' },
        callback = function(args)
          local ft = vim.bo[args.buf].filetype
          if ft == 'clojure' then
            vim.keymap.set('n', '<Enter>', ':Eval<CR>')
          elseif ft == 'cuda' then
            vim.o.expandtab = true
            vim.o.tabstop = 2
            vim.o.shiftwidth = 2
            vim.o.softtabstop = 2
          elseif ft == 'javascript' or ft == 'json' then
            vim.o.expandtab = true
            vim.o.shiftwidth = 2
            vim.o.softtabstop = 2
          end
        end
      })

      -- custom overrides
      vim.filetype.add({
        pattern = {
          [".*/%.kube/config"] = "yaml",
        },
      })
    '';
  };
}

{
  pkgs,
  config,
  lib,
  ...
}: {
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
      # misc
      {
        plugin = which-key-nvim;
        type = "lua";
        config = "require('which-key').setup {}";
      }

      # telescope
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
          table.insert(vimgrep_arguments, "!{.git/*,package-lock.json}")

          telescope.setup({
            defaults = {
              vimgrep_arguments = vimgrep_arguments,
            },
            pickers = {
              find_files = {
                find_command = {
                  "${pkgs.ripgrep}/bin/rg",
                  "--files",
                  "--hidden",
                  "--glob",
                  "!{.git/*}",
                  "--path-separator",
                  "/",
                },
            	},
            },
            extensions = {
              fzf = {
                fuzzy = true,
                override_generic_sorter = true,
                override_file_sorter = true,
                case_mode = "smart_case",
              },
              ["ui-select"] = {
                require("telescope.themes").get_cursor {}
              },
            }
          })
          telescope.load_extension('ui-select')

          local builtin = require("telescope.builtin")
          vim.keymap.set('n', '<Leader>f', builtin.find_files, { desc = "Telescope find files" })
          vim.keymap.set('n', '<Leader>g', builtin.live_grep, { desc = "Telescope live grep" })
          vim.keymap.set('n', '<Leader>d', builtin.diagnostics, { desc = "Telescope LSP diagnostics" })
          vim.keymap.set('n', 'z=', builtin.spell_suggest, { desc = "Telescope spell suggest" })
        '';
      }

      # navigation
      {
        plugin = harpoon2;
        type = "lua";
        config = ''
          local harpoon = require("harpoon")
          harpoon:setup()
          vim.keymap.set("n", "<leader>a", function()
            harpoon:list():add()
          end)
          vim.keymap.set("n", "<C-e>", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end)
        '';
      }
      {
        plugin = flash-nvim;
        type = "lua";
        config = ''
          vim.keymap.set({ "n", "x", "o"}, "zk",    function() require("flash").jump() end, { desc = "Flash" })
          vim.keymap.set({ "n", "x", "o"}, "Zk",    function() require("flash").treesitter() end, { desc = "Flash Treesitter" })
          vim.keymap.set("o",              "r",     function() require("flash").remote() end, { desc = "Remote Flash" })
          vim.keymap.set({ "x", "o"},      "R",     function() require("flash").treesitter_search() end, { desc = "Treesitter search" })
          vim.keymap.set({ "c"},           "<c-s>", function() require("flash").toggle() end, { desc = "Toggle Flash" })
        '';
      }

      # text editing / formatting
      {
        plugin = treesj;
        type = "lua";
        config = ''
          require('treesj').setup({})
        '';
      }
      {
        plugin = nvim-autopairs;
        type = "lua";
        config = ''
          require('nvim-autopairs').setup({})
        '';
      }
      {
        plugin = mini-surround;
        type = "lua";
        config = ''
          require('mini.surround').setup()
        '';
      }

      # theme
      {
        plugin = tokyonight-nvim;
        type = "lua";
        config = ''
          vim.o.termguicolors = true
          vim.o.background = 'dark'
          vim.cmd [[
            colorscheme tokyonight
            hi! Normal ctermbg=NONE guibg=NONE
            hi! NonText ctermbg=NONE guibg=NONE
          ]]
        '';
      }
      {
        plugin = lualine-nvim;
        type = "lua";
        config = ''
          require('lualine').setup({
            options = {
              theme = "tokyonight",
            },
          })
        '';
      }

      # zen mode
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

      vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
    '';
  };
}

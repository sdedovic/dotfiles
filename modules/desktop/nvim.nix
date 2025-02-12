{
  pkgs,
  config,
  lib,
  ...
}: {
  # terraform plus all these plugins makes neovim a little too heavy for my liking
  programs.neovim = {
    extraPackages = with pkgs; [
      terraform
      nil
      clang-tools
    ];
    plugins = with pkgs.vimPlugins; [
      # ui / theme / icons
      mini-icons
      nvim-web-devicons
      {
        plugin = fidget-nvim;
        type = "lua";
        config = ''
          require('fidget').setup({})
        '';
      }

      # additional languages
      vim-javascript
      vim-jsx-pretty
      vim-nix
      vim-terraform
      vim-glsl

      # clojure
      vim-fireplace
      cmp-conjure
      vim-jack-in
      vim-dispatch
      vim-dispatch-neovim
      {
        plugin = conjure;
        type = "lua";
        config = ''
          vim.g["conjure#filetypes"] = { "clojure" }
          vim.g["conjure#mapping#enable_defaults"] = false
        '';
      }

      # treesitter
      nvim-treesitter.withAllGrammars

      # markdown
      # TODO: mdmath.nvim -> LaTeX / TeX rendering
      render-markdown-nvim
      {
        plugin = markdown-preview-nvim;
        type = "lua";

        # TODO: custom CSS (https://github.com/m1chaelwilliams/my-nvim-config/blob/main/lua/plugins/mdprev.lua)
        config = ''
          vim.keymap.set("n", "<leader>mdn", ":MarkdownPreview<CR>")
          vim.keymap.set("n", "<leader>mds", ":MarkdownPreviewStop<CR>")
        '';
      }

      # formatting
      {
        plugin = conform-nvim;
        type = "lua";
        config = ''
          require("conform").setup({
            lsp_format = "fallback",
            formatters_by_ft = {
              rust = { "rustfmt" },
              nix = { "alejandra" },
              go = { "gofmt" },
              hcl = { "hcl" },
              json = { "jq" },
              tf = { "terraform_fmt" }
            },
            format_on_save = {
              lsp_format = "fallback"
            }
          })
        '';
      }

      # lsp and autocomplete
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = ''
          local lspconfig = require('lspconfig')
          local lsp_on_attach = function(_, bufnr)
            local opts = { buffer = true, silent = true }

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

          local capabilities = vim.tbl_deep_extend(
            'force',
            vim.lsp.protocol.make_client_capabilities(),
            require('cmp_nvim_lsp').default_capabilities(),
            { workspace = { didChangeWatchedFiles = { dynamicRegistration = true }}}
          )

          local servers = { 'rust_analyzer', 'pyright', 'ts_ls', 'nil_ls', 'clangd' }
          for _, lsp in ipairs(servers) do
            lspconfig[lsp].setup {
              on_attach = lsp_on_attach,
              capabilities = capabilities
            }
          end
        '';
      }
      cmp-nvim-lsp
      cmp-nvim-lsp-signature-help
      {
        plugin = nvim-cmp;
        type = "lua";
        config = ''
          local cmp = require('cmp')

          local cmp_autopairs = require('nvim-autopairs.completion.cmp')
          cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

          cmp.setup({
            preselect = cmp.PreselectMode.None, -- no idea
            window = {
              completion = cmp.config.window.bordered(),
              documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
              ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
              ['<C-d>'] = cmp.mapping.scroll_docs(4),  -- Down
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<C-e>'] = cmp.mapping.abort(),
              ['<CR>'] = cmp.mapping.confirm({
                -- idk what this does
                -- behaviour = cmp.ConfirmBehavior.Replace,

                -- Accept currently selected item. Set `select` to `false`
                --  to only confirm explicitly selected items.
                select = true,
              }),

              -- see above
              ['<Tab>'] = cmp.mapping.confirm({ select = true, }),
            }),
            sources = cmp.config.sources({
              { name = 'nvim_lsp' },
              { name = 'nvim_lsp_signature_help' },
              { name = 'conjure' },
            }, {
              { name = 'buffer' },
            })
          })
        '';
      }
    ];
  };
}

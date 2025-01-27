{
  pkgs,
  config,
  lib,
  ...
}:
{
  # terraform plus all these plugins makes neovim a little too heavy for my liking
  programs.neovim = {
    extraPackages = with pkgs; [ terraform ];
    plugins = with pkgs.vimPlugins; [
      # ui / theme / icons
      mini-icons
      nvim-web-devicons

      # additional languages
      vim-javascript
      vim-jsx-pretty
      vim-fireplace
      vim-nix
      vim-terraform
      vim-glsl

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

      # rich completions
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
              ['<C-b>'] = cmp.mapping.scroll_docs(-4),
              ['<C-f>'] = cmp.mapping.scroll_docs(4),
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<C-e>'] = cmp.mapping.abort(),
              ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
              -- ['<CR>'] = cmp.mapping.confirm({ select = false }),
            }),
            sources = cmp.config.sources({
              { name = 'nvim_lsp' },
              { name = 'nvim_lsp_signature_help' },
            }, {
              { name = 'buffer' },
            })
          })
        '';
      }
    ];
  };
}

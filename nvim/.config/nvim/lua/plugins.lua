return require('packer').startup(function(use)
	-- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- LSP Configs
  use 'neovim/nvim-lspconfig'

  -- Color Scheme?
  use 'tobi-wan-kenobi/zengarden'
  use 'jacoborus/tender.vim'
  use 'NLKNguyen/papercolor-theme'
  use 'sainnhe/gruvbox-material'

  -- Telescope
	use { 
		'nvim-telescope/telescope.nvim', tag = '0.1.0', 
		requires = { 
			{'nvim-lua/plenary.nvim'},
			{
				'nvim-telescope/telescope-fzf-native.nvim', 
				run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' 
			}
		} 
	}

  use {
    'folke/which-key.nvim',
    config = function()
      require('which-key').setup {}
    end
  }

  -- Language Specific
  use 'pangloss/vim-javascript'
  use 'maxmellon/vim-jsx-pretty'
  use 'tpope/vim-fireplace'
  use 'LnL7/vim-nix'
  use 'hashivim/vim-terraform'
end)

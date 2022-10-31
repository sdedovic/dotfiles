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

  use 'pangloss/vim-javascript'
  use 'maxmellon/vim-jsx-pretty'
end)

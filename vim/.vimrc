syntax on
set nu
filetype plugin indent on

set hlsearch            " highlight searches
set incsearch           " do incremental searching
set showmatch           " jump to matches when entering regexp
set ignorecase          " ignore case when searching
set smartcase           " no ignorecase if Uppercase char present

set visualbell t_vb=    " turn off error beep/flash
set novisualbell        " turn off visual bell
set nowrap 		" turn off line wrapping

set undofile 		" persistent history
set undodir=~/.vim/undo-dir/

set backspace=indent,eol,start


if has('macunix')	" assume things installed via homebrew
	set rtp+=/usr/local/opt/fzf
elseif has('unix')	" assume things installed via other
	set rtp+=~/.fzf " TODO: test if this works on arch?
endif

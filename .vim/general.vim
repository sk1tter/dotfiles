if !has('nvim')
    set undodir=~/.vim/undo//
endif

if has('nvim')
    source $HOME/.vim/nvim_defaults.vim
endif

set clipboard=unnamed
set cmdheight=2
set completeopt=menuone,noinsert,noselect
set cursorline
set expandtab
set hidden
set lazyredraw
set number
set mouse=a
set updatetime=300
set undofile
set signcolumn=yes
set t_Co=256

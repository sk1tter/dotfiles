let mapleader=' '

filetype plugin indent on
syntax on

set wildignore=*.o,*~,*.pyc,*pycache*,*.DS_Store,.git

set number
set relativenumber

set autoindent
set expandtab
set softtabstop=4
set shiftwidth=4
set shiftround

set mouse=a

set backspace=indent,eol,start
set hidden
set laststatus=2
set display=lastline
set statusline=%{toupper(mode())}\ %<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P

set showmode
set showcmd

set incsearch
set hlsearch

set ttyfast
set lazyredraw

set splitbelow
set splitright

set cursorline
set wrapscan
set report=0
set synmaxcol=200

set noswapfile
set helplang=en

set undodir=~/.vim/undodir
set undofile

if &t_Co > 16
    set termguicolors
endif

nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l

nnoremap <space> <nop>
vnoremap <space> <nop>

vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

nnoremap <leader>fv :Ex<CR>

nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y "+Y
xnoremap <leader>p" "_dP

nnoremap = :vertical resize +2<CR>
nnoremap - :vertical resize -2<CR>
nnoremap + :horizontal resize +2<CR>
nnoremap _ :horizontal resize -2<CR>

nnoremap Q <nop>

nnoremap [b :bprevious<CR>
nnoremap ]b :bnext<CR>

nnoremap n nzzzv
nnoremap N Nzzzv

nnoremap <expr> n 'Nn'[v:searchforward]
xnoremap <expr> n 'Nn'[v:searchforward]
onoremap <expr> n 'Nn'[v:searchforward]

nnoremap <expr> N 'nN'[v:searchforward]
xnoremap <expr> N 'nN'[v:searchforward]
onoremap <expr> N 'nN'[v:searchforward]

map <C-s> :w<CR>

vnoremap < <gv
vnoremap > >gv

" close certain buffers with q
augroup close_with_q
  autocmd!
  autocmd FileType help,man,qf call s:close_with_q()
augroup END

function! s:close_with_q() abort
  let buf = bufnr('%')
  call setbufvar(buf, '&buflisted', 0)
  nnoremap <buffer><silent> q :close<CR>
endfunction

" Only have cursorline highlighting in the active buffer
augroup window_controller
  autocmd!
  autocmd WinLeave * setlocal nocursorline
  autocmd WinEnter * setlocal cursorline
  autocmd WinLeave * call s:number_control(0)
  autocmd WinEnter * call s:number_control(1)
augroup END

function! s:number_control(value) abort
  if !&number && !&relativenumber
    return
  endif
  if a:value
    setlocal relativenumber
  else
    setlocal norelativenumber
  endif
endfunction

autocmd! BufReadPost *
 \ if &ft !~# 'commit\|rebase' && line("'\"") > 1 && line("'\"") <= line("$") | exe 'normal! g`"' | endif


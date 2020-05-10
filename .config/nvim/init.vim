" vim: set foldmethod=marker foldlevel=0 nomodeline:
" ============================================================================
" vim configurations {{{
" ============================================================================

augroup vimrc
	autocmd!
augroup END


let mapleader      = ' '
let maplocalleader = ' '

" }}}
" ============================================================================
" VIM-PLUG BLOCK {{{
" ============================================================================

silent! if plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf' 
Plug 'junegunn/fzf.vim'

" auto close brackets
Plug 'Raimondi/delimitMate'

" Colors
Plug 'arcticicestudio/nord-vim'

Plug 'itchyny/lightline.vim'

Plug 'tpope/vim-commentary'
    map  gc  <Plug>Commentary
    nmap gcc <Plug>CommentaryLine

Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
    let g:undotree_WindowLayout = 1
    nnoremap <leader>u :UndotreeToggle<CR>

Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
    augroup nerd_loader
      autocmd!
      autocmd VimEnter * silent! autocmd! FileExplorer
      autocmd BufEnter,BufNew *
            \  if isdirectory(expand('<amatch>'))
            \|   call plug#load('nerdtree')
            \|   execute 'autocmd! nerd_loader'
            \| endif
    augroup END
	let NERDTreeShowHidden=1
	let NERDTreeIgnore=['\.git$', '\.bloop$', '\.metals$', '\.DS_Store$', '\.vscode$', '^__pycache__$']

Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

Plug 'ryanoasis/vim-devicons'

" Git
Plug 'tpope/vim-fugitive'
    nmap     <Leader>g :Gstatus<CR>gg<c-n>
    nnoremap <Leader>d :Gdiff<CR>

" Languages
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'derekwyatt/vim-scala'

" lsp
Plug 'neoclide/coc.nvim',  {'branch': 'release'}


call plug#end()
endif

" }}}
" ============================================================================
" BASIC SETTINGS {{{
" ============================================================================

set langmenu=en_US
set encoding=utf-8

if !has('gui_running')
  set t_Co=256
endif

set nu
set autoindent
set tabstop=4
set shiftwidth=4
set laststatus=2
set expandtab smarttab
set visualbell
set backspace=indent,eol,start

" colorscheme nord
silent! colo nord

set hidden
set nobackup
set nowritebackup
set cmdheight=2
set updatetime=300
set shortmess+=c
set signcolumn=yes
set scrolloff=5
set list
set listchars=tab:\|\ ,
set autoread
set foldlevelstart=99

let &showbreak = '↳ '
set breakindent
set breakindentopt=sbr

set modelines=2
set synmaxcol=1000
set undodir=~/.vim/undodir
set undofile
set incsearch

set clipboard=unnamed

silent! set ttymouse=xterm2
set mouse=a

filetype plugin indent on
autocmd FileType scala setlocal shiftwidth=4 softtabstop=4 expandtab


" }}}
" ============================================================================
" MAPPINGS {{{
" ============================================================================

" ----------------------------------------------------------------------------
" Basic mappings
" ----------------------------------------------------------------------------

" split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" <leader>n | NERD Tree
nnoremap <leader>n :NERDTreeToggle<cr>

" ----------------------------------------------------------------------------
" Buffers
" ----------------------------------------------------------------------------
nnoremap ]b :bnext<cr>
nnoremap [b :bprev<cr>

" ----------------------------------------------------------------------------
" Tabs
" ----------------------------------------------------------------------------
nnoremap ]t :tabn<cr>
nnoremap [t :tabp<cr>

" }}}
" ============================================================================
" FUNCTIONS & COMMANDS {{{
" ============================================================================

let s:term_buf = 0
let s:term_win = 0

function! TermToggle(height)
    if win_gotoid(s:term_win)
        hide
    else
    setlocal splitbelow
        new terminal
        exec "resize ".a:height
        try
            exec "buffer ".s:term_buf
            exec "bd terminal"
        catch
            call termopen($SHELL, {"detach": 0})
            let s:term_buf = bufnr("")
            setlocal nonu nornu scl=no nocul
        endtry
        startinsert!
        let s:term_win = win_getid()
    endif
endfunction

nnoremap <silent><leader><C-T> :call TermToggle(12)<CR>
tnoremap <silent><leader><C-T> <C-\><C-n>:call TermToggle(12)<CR>

" }}}
" ============================================================================
" PLUGINS {{{
" ============================================================================

" ----------------------------------------------------------------------------
" lightline statusbar
" ----------------------------------------------------------------------------
let g:lightline = {
		\ 'colorscheme': 'nord',
		\ 'active': {
		\   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], [ 'cocstatus', 'currentfunction' ] ],
		\   'right': [ [ 'lineinfo' ],
		\            [ 'percent' ],
		\            [ 'fileformat', 'fileencoding', 'filetypeIcon' ] ]
		\ },
		\ 'component_function': {
		\   'fugitive': 'LightlineFugitive',
		\   'filename': 'LightlineFilename',
    	\   'cocstatus': 'coc#status',
        \   'currentfunction': 'CocCurrentFunction',
		\   'filetypeIcon': 'FileTypeIcon'
		\ },
		\ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
		\ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" }
		\ }
	function! LightlineModified()
		return &ft =~# 'help\|vimfiler' ? '' : &modified ? '+' : &modifiable ? '' : '-'
	endfunction
	function! LightlineReadonly()
		return &ft !~? 'help\|vimfiler' && &readonly ? '' : ''
	endfunction
	function! LightlineFilename()
		return winwidth(0) > 70 ? ((LightlineReadonly() !=# '' ? LightlineReadonly() . ' ' : '') .
		\ (&ft ==# 'vimfiler' ? vimfiler#get_status_string() :
		\  &ft ==# 'unite' ? unite#get_status_string() :
		\  &ft ==# 'vimshell' ? vimshell#get_status_string() :
		\ expand('%:t') !=# '' ? expand('%:t') : '[No Name]') .
		\ (LightlineModified() !=# '' ? ' ' . LightlineModified() : '')) : ''
	endfunction
	function! LightlineFugitive()
		if &ft !~? 'vimfiler' && exists('*FugitiveHead')
			let branch = FugitiveHead()
			return branch !=# '' ? '⎇ '.branch : ''
		endif
		return ''
	endfunction
	function! CocCurrentFunction()
    	return winwidth(0) > 120 ? (get(b:, 'coc_current_function', '')) : ''
	endfunction
	function! FileTypeIcon()
	  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
	endfunction
" ----------------------------------------------------------------------------
" coc.nvim
" ----------------------------------------------------------------------------
if has_key(g:plugs, 'coc.nvim')
    function! s:check_back_space() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    inoremap <silent><expr> <TAB>
          \ pumvisible() ? "\<C-n>" :
          \ <SID>check_back_space() ? "\<TAB>" :
          \ coc#refresh()
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

    function! s:show_documentation()
	if (index(['vim', 'help'], &filetype) >= 0)
            execute 'h' expand('<cword>')
        else
            call CocAction('doHover')
        endif
     endfunction

    nnoremap <silent> K :call <SID>show_documentation()<CR>

    let g:go_doc_keywordprg_enabled = 0
	let g:go_def_mapping_enabled = 0

    augroup coc-config
        autocmd!
        autocmd VimEnter * nmap <silent> gd <Plug>(coc-definition)
        autocmd VimEnter * nmap <silent> gi <Plug>(coc-implementation)
        autocmd VimEnter * nmap <silent> gr <Plug>(coc-references)
    augroup END
endif

" }}}
" ============================================================================
" FZF {{{
" ============================================================================

let $FZF_DEFAULT_OPTS .= ' --inline-info'

" All files
command! -nargs=? -complete=dir AF
    \ call fzf#run(fzf#wrap(fzf#vim#with_preview({
    \   'source': 'fd --type f --hidden --follow --exclude .git --no-ignore . '.expand(<q-args>)
    \ })))

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
    \ 'bg':      ['bg', 'Normal'],
    \ 'hl':      ['fg', 'Comment'],
    \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
    \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
    \ 'hl+':     ['fg', 'Statement'],
    \ 'info':    ['fg', 'PreProc'],
    \ 'border':  ['fg', 'Ignore'],
    \ 'prompt':  ['fg', 'Conditional'],
    \ 'pointer': ['fg', 'Exception'],
    \ 'marker':  ['fg', 'Keyword'],
    \ 'spinner': ['fg', 'Label'],
    \ 'header':  ['fg', 'Comment'] }

" Terminal buffer options for fzf
autocmd! FileType fzf
autocmd  FileType fzf set noshowmode noruler nonu

nnoremap <silent> <expr> <Leader><Leader> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":Files\<cr>"
nnoremap <silent> <Leader><Enter>  :Buffers<CR>
nnoremap <silent> <Leader>L        :Lines<CR>
nnoremap <silent> <Leader>rg       :Rg <C-R><C-W><CR>

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let options = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  if a:fullscreen
    let options = fzf#vim#with_preview(options)
  endif
  call fzf#vim#grep(initial_command, 1, options, a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)



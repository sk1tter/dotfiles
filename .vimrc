augroup vimrc
    autocmd!
augroup END

let mapleader      = ' '
let maplocalleader = ' '

syntax on
set number
set laststatus=2
set autoindent
set showcmd
set smarttab
set backspace=indent,eol,start

set hidden
set nobackup
set nowritebackup
set cmdheight=2
set updatetime=300
set shortmess+=c
set scrolloff=5
set list
set listchars=tab:\|\ ,
set autoread
set foldlevelstart=99

set modelines=2
set synmaxcol=1000
set undodir=~/.vim/undodir
set undofile
set incsearch

set clipboard=unnamed

silent! set ttymouse=xterm2
set mouse=a

" Keep the cursor on the same column
set nostartofline

" qq to record, Q to replay
nnoremap Q @q

filetype plugin indent on
autocmd FileType scala setlocal shiftwidth=4 softtabstop=4 expandtab

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nnoremap ]b :bnext<cr>
nnoremap [b :bprev<cr>


nnoremap ]t :tabn<cr>
nnoremap [t :tabp<cr>

function! s:statusline_expr()
    let mod = "%{&modified ? '[+] ' : !&modifiable ? '[x] ' : ''}"
    let ro  = "%{&readonly ? '[RO] ' : ''}"
    let ft  = "%{len(&filetype) ? '['.&filetype.'] ' : ''}"
    let fug = "%{exists('g:loaded_fugitive') ? fugitive#statusline() : ''}"
    let sep = ' %= '
    let pos = ' %-12(%l : %c%V%) '
    let pct = ' %P'

    return '[%{mode()}:%n] %F %<'.mod.ro.ft.fug.sep.pos.'%*'.pct
endfunction
let &statusline = s:statusline_expr()


function! ToggleNetrw()
    let i = bufnr("$")
    let wasOpen = 0
    while (i >= 1)
        if (getbufvar(i, "&filetype") == "netrw")
            silent exe "bwipeout " . i
            let wasOpen = 1
        endif
        let i-=1
    endwhile
    if !wasOpen
        silent Lexplore
    endif
endfunction
nnoremap <leader>n :call ToggleNetrw() <CR>

let g:netrw_banner=0        " disable annoying banner
let g:netrw_winsize = 18    " width in percent
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view


let g:terminal_drawer = { 'win_id': v:null, 'buffer_id': v:null }
function! TermToggle() abort
    if win_gotoid(g:terminal_drawer.win_id)
        hide
        set laststatus=2 showmode ruler
    else
    if !g:terminal_drawer.buffer_id
        botright call term_start($SHELL)
        let g:terminal_drawer.buffer_id = bufnr("$")
    else
        execute 'botright sbuffer' . g:terminal_drawer.buffer_id
        exec 'normal! i'
    endif

    exec "resize" float2nr(&lines * 0.25)
    setlocal laststatus=0 noshowmode noruler
    setlocal nobuflisted
    let g:terminal_drawer.win_id = win_getid()
    endif
endfunction

nnoremap <silent><leader><C-T> :call TermToggle()<CR>
tnoremap <silent><leader><C-T> <C-\><C-n>:call TermToggle()<CR>


function! s:helptab()
    if &buftype == 'help'
        wincmd T
        nnoremap <buffer> q :q<cr>
    endif
endfunction
autocmd vimrc BufEnter *.txt call s:helptab()

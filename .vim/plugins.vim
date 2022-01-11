" Autoinstall vim-plug if not installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif


call plug#begin('~/.vim/plugged')

if has('nvim')
    Plug 'shaunsingh/nord.nvim'
else
   jPlug 'arcticicestudio/nord-vim'
endif

Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

Plug 'itchyny/lightline.vim'
Plug 'jiangmiao/auto-pairs'

Plug 'udalov/kotlin-vim', { 'for': 'kotlin' }

" Neovim specific plugins
Plug 'neovim/nvim-lspconfig', has('nvim') ? {} : { 'on': [] }
Plug 'ms-jpq/coq_nvim', has('nvim') ? {} : { 'on': [], 'branch': 'coq' }
Plug 'ms-jpq/coq.artifacts', has('nvim') ? {} : { 'on': [], 'branch': 'artifacts'}
Plug 'nvim-treesitter/nvim-treesitter', has('nvim') ? {} : { 'on': [], 'do': ':TSUpdate'}
Plug 'p00f/nvim-ts-rainbow', has('nvim') ? {} : { 'on': [] }
Plug 'nvim-lua/plenary.nvim', has('nvim') ? {} : { 'on': []}
Plug 'scalameta/nvim-metals', has('nvim') ? {} : { 'on': [], 'for': 'scala'}


Plug 'github/copilot.vim', has('nvim') ? {} : { 'on': [] }

" Git
Plug 'tpope/vim-fugitive'
    nmap     <Leader>g :Gstatus<CR>gg<c-n>
    nnoremap <Leader>d :Gdiff<CR>
    
Plug 'tpope/vim-commentary'
    map  gc  <Plug>Commentary
    nmap gcc <Plug>CommentaryLine


call plug#end()



filetype plugin indent on


silent! colo nord


" nvim lst, treesitter
if has('nvim')
    source $HOME/.vim/nvim_lsp.vim
    source $HOME/.vim/nvim_treesitter.vim
endif

" FZF
let $FZF_DEFAULT_OPTS .= ' --inline-info'
" All files
command! -nargs=? -complete=dir AF
    \ call fzf#run(fzf#wrap(fzf#vim#with_preview({
    \   'source': 'fd --type f --hidden --follow --exclude .git --no-ignore . '.expand(<q-args>)
    \ })))
" Terminal buffer options for fzf
autocmd! FileType fzf
autocmd  FileType fzf set noshowmode noruler nonu

command! -bang -nargs=* GitFiles call fzf#run(fzf#vim#with_preview(fzf#wrap({'source':
            \"bash -c 'git diff --name-only HEAD~ && git ls-files -o --exclude-standard'"})))
nnoremap <Leader>b  :Buffers<CR>
nnoremap <Leader>g  :Files<CR>
nnoremap <Leader>l        :Lines<CR>
nnoremap <Leader>r     :Rg<CR>
nnoremap <Leader>h :GitFiles<CR>

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

" nvim-toggle terminal
if has('nvim')
    let s:term_buf = 0
    let s:term_win = 0

    function! s:TermToggle(height) abort
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

    nnoremap <silent><F4> :call <SID>TermToggle(12)<CR>
    tnoremap <silent><F4> <C-\><C-n>:call <SID>TermToggle(12)<CR>
else
    if has('terminal')
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

        nnoremap <silent><F4> :call TermToggle()<CR>
        tnoremap <silent><F4> <C-\><C-n>:call TermToggle()<CR>
    endif
endif


function! ToggleVExplorer()
      Lexplore
      " vertical resize 30
endfunction

map <silent> <Leader>n :call ToggleVExplorer()<CR>

" absolute width of netrw window
let g:netrw_winsize = -30
" Hit enter in the file browser to open the selected
" file with :vsplit to the right of the browser.
" let g:netrw_browse_split = 4
" let g:netrw_altv = 1

" tree-view
let g:netrw_liststyle = 3

" Change directory to the current buffer when opening files.

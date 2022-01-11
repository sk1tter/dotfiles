
" lightline statusbar
let g:lightline = {
    \ 'colorscheme': g:colors_name,
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], [ 'linterstatus' ] ],
        \   'right': [ [ 'lineinfo' ],
        \            [ 'percent' ],
        \            [ 'fileformat', 'fileencoding', 'filetypeIcon' ] ]
        \ },
        \ 'component_function': {
        \   'fugitive': 'LightlineFugitive',
        \   'filename': 'LightlineFilename',
        \   'linterstatus': 'LinterStatus',
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
        return winwidth(0) > 70 ? (branch !=# '' ? '⎇ '.branch : '') : ''
    endif
    return ''
endfunction

function! LinterStatus() abort
    let l:buf = bufnr('')
    if !has('nvim')
        return ''
    endif

    let l:errors = s:count('ERROR')
    let l:warnings = s:count('WARN')

    if l:errors == 0 && l:warnings == 0
        return ' ✓ ok '
    else
        return printf(' ⚠ %d x %d ', warnings, errors)
    endif
endfunction

function! s:count(level) abort
  let l:result = luaeval('vim.diagnostic.get(' . bufnr() . ', { severity = vim.diagnostic.severity.' . a:level . '})')
  return len(l:result)
endfunction

set laststatus=2

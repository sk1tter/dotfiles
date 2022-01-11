
nnoremap <silent> <leader>/ :noh<cr>
" split navigations
" nnoremap <C-J> <C-W><C-J>
" nnoremap <C-K> <C-W><C-K>
" nnoremap <C-L> <C-W><C-L>
" nnoremap <C-H> <C-W><C-H>
"
" Buffers
nnoremap ]b :bnext<cr>
nnoremap [b :bprev<cr>

" Tabs
nnoremap ]t :tabn<cr>
nnoremap [t :tabp<cr>

"Remove all trailing whitespace by pressing F5
nnoremap <silent><F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>:noh<CR>

" qq to record, Q to replay
nnoremap Q @q

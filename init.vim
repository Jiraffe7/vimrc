call plug#begin('~/.config/nvim/plugged')

Plug 'tpope/vim-surround'
"Plug 'terryma/vim-multiple-cursors'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'scrooloose/nerdtree'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-gitgutter'

"Plug 'altercation/vim-colors-solarized'

call plug#end()

let mapleader=" "

" Window mappings
nnoremap <Leader>o :split<CR>
nnoremap <Leader>e :vsplit<CR>
nnoremap <C-S-h> <C-w>h
nnoremap <C-S-j> <C-w>j
nnoremap <C-S-k> <C-w>k
nnoremap <C-S-l> <C-w>l
set splitright
set splitbelow

" Copy paste mappings
vnoremap <Leader>c "+y
vnoremap <Leader>v "+p
nnoremap <Leader>v "+p

nnoremap <Leader>f :Files<CR>

let NERDTreeShowHidden=1
nnoremap <Leader>n :NERDTreeToggle<CR>
nnoremap <Leader>j :NERDTreeFind<CR>

nnoremap <Leader>g :RG<CR>
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --hidden --ignore-case --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
  \           : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '?'),
  \   <bang>0)

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

set number

set expandtab
set shiftwidth=4
set softtabstop=4
set smartindent

"let g:solarized_termtrans = 1
"colorscheme solarized
"set background=dark

highlight clear SignColumn

" python run command with S-F10 which maps to F22
autocmd FileType python map <buffer> <F22> :w<CR>:exec '!python' shellescape(@%, 1)<CR>
autocmd FileType python imap <buffer> <F22> <esc>:w<CR>:exec '!python' shellescape(@%, 1)<CR>

call plug#begin('~/.config/nvim/plugged')

Plug 'tpope/vim-surround'
Plug 'terryma/vim-multiple-cursors'
Plug 'scrooloose/nerdtree'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-gitgutter'

Plug 'altercation/vim-colors-solarized'

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

nnoremap <Leader>f :Files<CR>

let NERDTreeShowHidden=1
nnoremap <Leader>n :NERDTreeToggle<CR>
nnoremap <Leader>j :NERDTreeFind<CR>

nnoremap <Leader>g :Rg<CR>

set number

set expandtab
set shiftwidth=4
set softtabstop=4
set smartindent

let g:solarized_termtrans = 1
colorscheme solarized
set background=dark

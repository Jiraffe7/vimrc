call plug#begin('~/.config/nvim/plugged')

Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-surround'
"Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'scrooloose/nerdtree'
Plug 'itchyny/lightline.vim'
"Plug 'mengelbrecht/lightline-bufferline'
Plug 'andymass/vim-matchup'
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-gitgutter'
" Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Semantic language support
Plug 'neovim/nvim-lspconfig'

call plug#end()

let mapleader=" "

" Window mappings
nnoremap <Leader>o :split<CR>
nnoremap <Leader>e :vsplit<CR>
" remove convenience window moves because clash with ctrl-j/k as escape
" nnoremap <C-h> <C-w>h
" nnoremap <C-j> <C-w>j
" nnoremap <C-k> <C-w>k
" nnoremap <C-l> <C-w>l
set splitright
set splitbelow

" Copy paste mappings
vnoremap <Leader>c "+y
vnoremap <Leader>v "+p
nnoremap <Leader>v "+p

nnoremap <Leader>f :Files<CR>
nnoremap <Leader>b :Buffers<CR>

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

let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'readonly', 'relativepath', 'modified' ] ],
      \ }
      \ }

" lightline-bufferline settings
"let g:lightline#bufferline#show_number  = 1
"let g:lightline#bufferline#shorten_path = 0
"let g:lightline#bufferline#unnamed      = '[No Name]'
"
"let g:lightline.tabline          = {'left': [['buffers']], 'right': [['close']]}
"let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
"let g:lightline.component_type   = {'buffers': 'tabsel'}
"set showtabline=2

set relativenumber
set number

set noexpandtab
set shiftwidth=8
set softtabstop=8
set tabstop=8
set smartindent

set ignorecase
set smartcase

set termguicolors
set background=dark
let base16colorspace=256
let g:base16_shell_path="~/.config/nvim/colors"
colorscheme base16-gruvbox-dark-hard

highlight clear SignColumn

au TextYankPost * silent! lua vim.highlight.on_yank {timeout=1500}

let g:go_def_mode='gopls'
let g:go_info_mode='gopls'

" python run command with S-F10 which maps to F22
autocmd FileType python map <buffer> <F22> :w<CR>:exec '!python' shellescape(@%, 1)<CR>
autocmd FileType python imap <buffer> <F22> <esc>:w<CR>:exec '!python' shellescape(@%, 1)<CR>


" LSP configuration
lua << END

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
end

lspconfig = require "lspconfig"
util = require "lspconfig/util"

lspconfig.gopls.setup {
  on_attach = on_attach,
  cmd = {"gopls"},
  filetypes = {"go", "gomod", "gotmpl"},
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  single_file_support = true,
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
}
--require('lspconfig')['rust_analyzer'].setup{
--    on_attach = on_attach,
--    -- Server-specific settings...
--    settings = {
--      ["rust-analyzer"] = {}
--    }
--}
END

" copied from github.com/jonhoo/configs

" Quick-save
nmap <leader>w :w<CR>

set scrolloff=2
let g:sneak#s_next = 1
" Always draw sign column. Prevent buffer moving when adding/deleting sign.
set signcolumn=yes

" Decent wildmenu
set wildmenu
set wildmode=list:longest

" Search results centered please
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz

set mouse=a " Enable mouse usage (all modes) in terminals

" ; as :
nnoremap ; :
" map <leader>; since ; is mapped to :
nnoremap <leader>; ;

" Ctrl+j and Ctrl+k as Esc
nnoremap <C-j> <Esc>
inoremap <C-j> <Esc>
vnoremap <C-j> <Esc>
snoremap <C-j> <Esc>
xnoremap <C-j> <Esc>
cnoremap <C-j> <C-c>
onoremap <C-j> <Esc>
lnoremap <C-j> <Esc>
tnoremap <C-j> <Esc>

nnoremap <C-k> <Esc>
inoremap <C-k> <Esc>
vnoremap <C-k> <Esc>
snoremap <C-k> <Esc>
xnoremap <C-k> <Esc>
cnoremap <C-k> <C-c>
onoremap <C-k> <Esc>
lnoremap <C-k> <Esc>
tnoremap <C-k> <Esc>
"
" Ctrl+/ to stop searching
vnoremap <C-_> :nohlsearch<cr>
nnoremap <C-_> :nohlsearch<cr>

" Jump to start and end of line using the home row keys
map H ^
map L $

" <leader><leader> toggles between buffers
nnoremap <leader><leader> <c-^>

" Permanent undo
set undodir=~/.local/share/nvim/undo//
set undofile

" I can type :help on my own, thanks.
map <F1> <Esc>
imap <F1> <Esc>

" No arrow keys --- force yourself to use the home row
nnoremap <up> <nop>
nnoremap <down> <nop>
" Left and right can switch buffers
nnoremap <left> :bp<CR>
nnoremap <right> :bn<CR>

filetype plugin indent on

set nocompatible

"set guifont=Ubuntu\ Mono\ 10

set modelines=0
syntax on

set iskeyword=a-z,A-Z,_,.,39

set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

set scrolloff=3
set autoindent
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest
set visualbell
"set cursorline
"set ttyfast
set ruler
set backspace=indent,eol,start
set laststatus=2
"set relativenumber
"set undofile

let mapleader=","

set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch

set nowrap
set textwidth=79
set formatoptions=qrn1
"set colorcolumn=85

"For all modes...
noremap <c-g> <esc>

"Sane j/k remaps
nnoremap j gj
nnoremap k gk

nnoremap <c-.> :tag<cr>
nnoremap <c-,> :tagstack<cr>

"Leader mods
nnoremap <leader><space> :noh<cr>
nnoremap <leader>v V`]

nnoremap <c-w>b :bu 

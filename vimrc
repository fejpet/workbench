set expandtab
set tabstop=2
set shiftwidth=2
set autoindent
set smartindent
set cindent
syntax on
filetype plugin indent on

set number
" set relativenumber

" --- refactoring: replace current word ---
map <leader>fr *:%s//

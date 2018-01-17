colorscheme aldmeris
version 8.0

set backspace=indent,eol,start
filetype on
filetype plugin on
filetype indent on
set history=1000
set nobackup
set nowritebackup
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
syntax on
set termencoding=utf-8
set wildmode=longest

map ,e :e <C-R>=expand("%:p:h") . "/" <CR>
nmap <SPACE> :noh<CR>
nnoremap Y y$
imap jk <Esc>
set smartindent
set smarttab
syntax on

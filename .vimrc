colorscheme aldmeris
version 8.0

set backspace=indent,eol,start
filetype on
filetype plugin on
filetype indent on
set history=1000
set laststatus=2
set nobackup
set nowritebackup
set ruler
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
syntax on
set termencoding=utf-8

" open in current dir of file
map ,e :e <C-R>=expand("%:p:h") . "/" <CR>
" fuzzy find file
nnoremap ,E :e **/*

nmap <SPACE> :noh<CR>
nnoremap Y y$
imap jk <Esc>
set smartindent
set smarttab
syntax on
let c_space_errors = 1

set vb t_vb=     " no visual bell

set wildmenu
set wildmode=list:longest,full
" Don't offer to open certain files/directories
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png,*.ico
set wildignore+=*.pdf,*.psd,*.o

let g:rustfmt_autosave = 1
let g:rustfmt_command = 'rustup run stable rustfmt'

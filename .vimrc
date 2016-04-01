colorscheme zenburn
version 6.0
if &cp | set nocp | endif
let s:cpo_save=&cpo
set cpo&vim
map! <S-Insert> <MiddleMouse>
nmap d :cs find d =expand("<cword>")
nmap i :cs find i ^=expand("<cfile>")$
nmap f :cs find f =expand("<cfile>")
nmap e :cs find e =expand("<cword>")
nmap t :cs find t =expand("<cword>")
nmap c :cs find c =expand("<cword>")
nmap g :cs find g =expand("<cword>")
nmap s :cs find s =expand("<cword>")
nmap gx <Plug>NetrwBrowseX
nnoremap <silent> <Plug>NetrwBrowseX :call netrw#NetrwBrowseX(expand("<cWORD>"),0)
nmap <Nul><Nul>d :vert scs find d =expand("<cword>")
nmap <Nul><Nul>i :vert scs find i ^=expand("<cfile>")$
nmap <Nul><Nul>f :vert scs find f =expand("<cfile>")
nmap <Nul><Nul>e :vert scs find e =expand("<cword>")
nmap <Nul><Nul>t :vert scs find t =expand("<cword>")
nmap <Nul><Nul>c :vert scs find c =expand("<cword>")
nmap <Nul><Nul>g :vert scs find g =expand("<cword>")
nmap <Nul><Nul>s :vert scs find s =expand("<cword>")
nmap <Nul>d :scs find d =expand("<cword>")
nmap <Nul>i :scs find i ^=expand("<cfile>")$
nmap <Nul>f :scs find f =expand("<cfile>")
nmap <Nul>e :scs find e =expand("<cword>")
nmap <Nul>t :scs find t =expand("<cword>")
nmap <Nul>c :scs find c =expand("<cword>")
nmap <Nul>g :scs find g =expand("<cword>")
nmap <Nul>s :scs find s =expand("<cword>")
map <S-Insert> <MiddleMouse>
let &cpo=s:cpo_save
unlet s:cpo_save
set background=dark
set backspace=indent,eol,start
set cscopetag
set cscopeverbose
set fileencodings=ucs-bom,utf-8,default,latin1
set guioptions=
set helplang=en
set history=50
set is hlsearch
set ic smartcase
set nomodeline
set mouse=a
set printoptions=paper:letter
set ruler
set runtimepath=~/.vim,/var/lib/vim/addons,/usr/share/vim/vimfiles,/usr/share/vim/vim74
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
set termencoding=utf-8
set wildmode=longest
map ,e :e <C-R>=expand("%:p:h") . "/" <CR>
set tabstop=8
"set expandtab
set smartindent
"set shiftwidth=4
set smarttab
syntax on
set textwidth=80
set fo-=t
"set colorcolumn=+1
set window=91
set wildchar=<Tab> wildmenu wildmode=longest,list,full
nmap <SPACE> :noh<CR>
imap jk <Esc>
nnoremap Y y$
" motion keys in insert mode
"inoremap <c-j> <c-o>j
"inoremap <c-k> <c-o>k
"inoremap <c-l> <c-o>l
"inoremap <c-h> <c-o>h
"inoremap <c-e> <c-o>$
"inoremap <c-a> <c-o>^
"inoremap <M-f> <c-right>
"inoremap <M-b> <c-left>
"inoremap <M-d> <c-o>dw
"inoremap <c-d> <c-o>x
" and in command mode
"cnoremap <c-j> <c-o>j
"cnoremap <c-k> <c-o>k
"cnoremap <c-l> <c-o>l
"cnoremap <c-h> <c-o>h
"cnoremap <c-e> <c-o>$
"cnoremap <c-a> <c-o>^
"cnoremap <M-f> <c-right>
"cnoremap <M-b> <c-left>
"cnoremap <M-d> <c-o>dw
"cnoremap <c-d> <c-o>x
" vim: set ft=vim :
augroup vimrc_autocmds
    au!
    autocmd BufEnter,BufReadPost,BufNewFile * highlight TooLong ctermbg=darkmagenta
    autocmd BufReadPost,BufReadPost,BufNewFile *.c,*.cc,*.h,*.cpp,*.java,*.inl match TooLong /\%>80v./
    autocmd BufReadPost,BufReadPost,BufNewFile *.c,*.h set cindent
    autocmd BufReadPost,BufReadPost,BufNewFile *.c,*.h set cinoptions=:0,l1,t0,g0,(0
    autocmd BufReadPost,BufReadPost,BufNewFile *pulseaudio/*.c,*pulseaudio/*.h match TooLong /\%>128v./
    autocmd BufEnter,BufReadPost,BufNewFile * highlight ExtraWhitespace ctermbg=darkmagenta
    autocmd BufEnter,BufReadPost,BufNewFile * 2match ExtraWhitespace /\s\+$\| \+\ze\t/
augroup END

call pathogen#infect()
call pathogen#helptags()

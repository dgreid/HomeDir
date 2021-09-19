version 8.0

set backspace=indent,eol,start
filetype on
filetype plugin on
filetype indent on
" write buffers when switching away from them.
set autowrite
set history=1000
set laststatus=2
set nobackup
set nowritebackup
set ruler
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
syntax on
set termencoding=utf-8

set background=dark
let g:gruvbox_italic=0
let g:gruvbox_contrast_dark='hard'
colorscheme gruvbox

" open in current dir of file
map ,e :e <C-R>=expand("%:p:h") . "/" <CR>
" fuzzy find file
nnoremap ,E :e **/*

" persistent undo
set undofile
set undodir=~/.vim/undofiles

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
let g:rustfmt_command = "rustfmt --edition=2018"


if executable('rust-analyzer')
  au User lsp_setup call lsp#register_server({
        \   'name': 'Rust Analyzer',
        \   'cmd': {server_info->['rust-analyzer']},
        \   'whitelist': ['rust'],
        \ })
endif

if executable('clangd')
    augroup lsp_clangd
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
                    \ 'name': 'clangd',
                    \ 'cmd': {server_info->['clangd']},
                    \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
                    \ })
        autocmd FileType asm setlocal omnifunc=lsp#complete
        autocmd FileType c setlocal omnifunc=lsp#complete
        autocmd FileType cpp setlocal omnifunc=lsp#complete
        autocmd FileType objc setlocal omnifunc=lsp#complete
        autocmd FileType objcpp setlocal omnifunc=lsp#complete
    augroup end
endif


function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gy <plug>(lsp-type-definition)
    nmap <buffer> gn <plug>(lsp-rename)
    nmap <buffer> gh <plug>(lsp-hover)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    inoremap <buffer> <expr><c-f> lsp#scroll(+4)
    inoremap <buffer> <expr><c-d> lsp#scroll(-4)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

let g:vimwiki_list = [{ 'path': '~/notes', 'syntax':'markdown', 'ext': '.md' }]
autocmd FileType vimwiki set ft=markdown

" Get the git branch name for the current buffer.
function! GitBranch()
	return system(printf("git -C %s rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'", expand('%:p:h:S')))
endfunction

" Caches the git branch name when loading/reading a buffer so git doesn't get
" called for each update.
augroup gitbranch
	au!
	autocmd BufEnter,FocusGained,BufWritePost * let b:git_branchname = GitBranch()
augroup end

" Returns the cached (in b:git_branchname) git branchname if it is set.
function! BranchOrNone()
	return get(b:, "git_branchname", "")
endfunction

set statusline=
set statusline+=%#PmenuSel#
set statusline+=%{BranchOrNone()}
set statusline+=%#LineNr#
set statusline+=\ %f
set statusline+=%m%r
set statusline+=%=
set statusline+=%#CursorColumn#
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c
set statusline+=\

set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

"This is the Vundle package, which can be found on Github.
"For Github repos, you specify plugins using the
" 'user/repository' format
Plugin 'gmarik/vundle'



"Now we can turn on the filetype functionality back on 
filetype plugin indent on

syntax on
set ignorecase
set bs=2 " backspace=2 allows you to use the backspace key
set ai "autoindent inserts the indentaion from the current line when you start a newline
set aw "autowrite automatically write file if changed
set backup "keep a backup file after overwriting a file
set viminfo='20,\"50 "use .viminfo file in startup and exit, do not store morehtan 50 lines of registers
set ruler "shows the cursor ruler at the bottom linum/colnum
set printoptions=header:0 "dont print a header
set printfont=courier:h8
set wildmenu
set backspace=indent,eol,start
set backup
set history=50
set showcmd
set incsearch
set hlsearch
set dictionary=/usr/share/dict/words
set complete=.,w,b,u,t,i,k
"set enc=utf-8
let g:netrw_list_hide='^\..*'

set cursorline

"arrangment of new splits
set splitbelow
set splitright

"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"background tab
map :bt :tab split<CR>gT :q<CR>

" switch between source and header files easily
nmap ,s :find %:t:r.cpp<cr>
nmap ,S :sf %:t:r.cpp<cr>

nmap ,h :find %:t:r.h<cr>
nmap ,H :sf %:t:r.h<cr>

"turn on line numbering, and toggle it on/off with F3
set number
nnoremap <F3> :set invnumber number?<CR>

"Allow toggling of paste with F2 when in insert mode. 
nnoremap <F2> :set invpaste paste?<CR>
"set pastetoggle=<F2>

if has("autocmd")

  filetype plugin indent on
  augroup vimrcEx
  au!
" For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
  autocmd FileType tex setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
  augroup END

else

  set autoindent

endif

if has("unix")
	map ,e :e <C-R>=expand("%:p:h") . "/" <CR>
else
	map ,e :e <C-R>=expand("%:p:h") . "\" <CR>
endif

" :s/foo/\0stuff/     foo -> foostuff
:let g:netrw_browsex_viewer="open"

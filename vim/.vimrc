set nocompatible "enables features that aren't compatible with vi"
execute pathogen#infect()
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

map Q gq

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

"  key-mappings for comment line in normal mode
noremap  <silent> gk :call CommentLine()<CR>
" key-mappings for range comment lines in visual <Shift-V> mode
vnoremap <silent> gk :call RangeCommentLine()<CR>
" key-mappings for un-comment line in normal mode
noremap  <silent> gK :call UnCommentLine()<CR>
" key-mappings for range un-comment lines in visual <Shift-V> mode
vnoremap <silent> gK :call RangeUnCommentLine()<CR>
"map gk :s/^/\/\//<CR>:let @/=""<CR>
"map gK :s/^\/\/\\|^--\\|^> \\|^[#"%!;]//<CR>
"map gl 0i#<Esc>
"vmap gl :s/^/#<CR>
map gp :!ipython % <CR>
map gr :!./% <CR>
map gX :!chmod +x % <CR>
map gb :!open % <CR>
map :Q :q
map :WQ :wq
map :Spell :setlocal spell spelllang=en_gb <CR>
vmap g# :s/^/#/ <CR>
vmap g* :s/^#// <CR>
map gt :TlistToggle <CR>
set cursorline

" taglist
let Tlist_Exit_OnlyWindow = 1
" tabstop
set tabstop=4
set expandtab
set shiftwidth=4 " or whatever
set smarttab autoindent

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

" vim latex
filetype plugin on
set grepprg=grep\ -nH\ $*
filetype indent on


if has("unix")
	map ,e :e <C-R>=expand("%:p:h") . "/" <CR>
else
	map ,e :e <C-R>=expand("%:p:h") . "\" <CR>
endif
" :s/foo/\0stuff/     foo -> foostuff
:let g:netrw_browsex_viewer="open"

"Allows my chosen cursorline settings when vi starts and then uses keymapping
"to set again if I change colorscheme
"augroup GreyCursorLine
        "autocmd!
        "autocmd

"autocmd BufEnter * hi LineNr ctermfg=241 ctermbg=232
"autocmd BufEnter * call s:SetCursorLine()
"autocmd Colorscheme * call s:SetCursorLine()
"function s:SetCursorLine()
        "set cursorline
        "hi CursorLine cterm=bold ctermbg=darkgrey ctermfg=none
"endfunction
"map <leader>c :hi CursorLine cterm=bold ctermbg=darkgrey ctermfg=none  <CR>

"Why doesn't this way work?
"set cursorline
":nnoremap <Leader>c hi CursorLine cterm=bold ctermbg=darkgrey ctermfg=none<CR>

" highlighting for opts files
au BufRead,BufNewFile *.opts setlocal filetype=cpp

" read pdf files in vim
autocmd BufReadPre *.pdf set ro
autocmd BufReadPost *.pdf %!pdftotext -nopgbrk "%" -

" read .doc files in vim
autocmd BufReadPre *.doc set ro
" autocmd BufReadPre *.doc set hlsearch!
autocmd BufReadPost *.doc %!antiword "%"


"switch on spellcheck for tex files
autocmd FileType tex set spell spelllang=en_gb
autocmd FileType txt set spell spelllang=en_gb


"set latex filetype
let g:tex_flavor = "latex"

"Allow toggling of paste with F2 when in insert mode. Also gives visual feedback in statusline.V
nnoremap <F2> :set invpaste paste?<CR>
"set pastetoggle=<F2>

set number
nnoremap <F3> :set invnumber number?<CR>
"set numtoggle=<F3>

"set t_Co=256
" jk is escape
"inoremap jk <esc>

""""Vim Solarized
set background=light
colo solarized
call togglebg#map("<F5>")

"""""Airline""""""
set laststatus=2
"let g:bufferline_echo=0
set noshowmode
let g:airline_powerline_fonts = 1
" enter normal mode (esc) without waiting for timeoutlen
" fixes Powerline delay
augroup FastEscape
  autocmd!
  au InsertEnter * set timeoutlen=0
  au InsertLeave * set timeoutlen=1000
augroup END

"""""git
autocmd Filetype gitcommit setlocal spell textwidth=72

""""Syntastic 
"Recommended settings from readme
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers = ['pyflakes']
"" Turn off syntastic for latex files.
let g:syntastic_mode_map = {
        \ "mode": "active",
        \ "active_filetypes": [],
        \ "passive_filetypes": ["tex"] }



au FileType mail call FT_mail()

function FT_mail()
    set nocindent
    set noautoindent
    set textwidth=68
    set nonumber
    " reformat for 72 char lines
    " normal gggqGgg
    " settings
    setlocal spell spelllang=en
    " setlocal fileencoding=iso8859-1,utf-8
    set fileencodings=iso8859-1,utf-8
    " abbreviations
    iabbr  gd Good Day!
endfunction
set clipboard=unnamed
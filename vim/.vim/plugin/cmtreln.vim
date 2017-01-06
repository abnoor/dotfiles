"
" Maintainer:   Kurt Rinnert <kurt.rinnert@cern.ch>
" Last Change:  Sun Aug 20 19:03:10 BST 2006
"
" DESCRIPTION:
"   Sets filetype upon buffer creation or reading, thereby enabling the
"   release note syntax highlighting. Also triggers insertion of a header
"   template if a new release note file is created.  Makes some helpful
"   settings for tab and indenting as well.
"   
"   Enjoy, and happy vimming!
"

"
" bail out if already loaded or compatibility mode is set
"
if exists("loaded_cmtreln") || &cp
  finish
endif

"
" functions to be executed when a release.note file is
" created
"
function! <SID>CmtRelNoteHeader()
    call append(line("$")-1,'!-----------------------------------------------------------------------------')
    call append(line("$")-1,'! Package     :  ')
    if exists("g:userEMail")
      call append(line("$")-1,'! Responsible : '.g:userFullName.' <'.g:userEMail.'>')
    else
      call append(line("$")-1,'! Responsible : '.g:userFullName)
    endif
    call append(line("$")-1,'! Purpose     : ')
    call append(line("$")-1,'!-----------------------------------------------------------------------------')
    call append(line("$")-1,'')
    call cursor(2,17)
endfunction

"
" mapping to function calls for new buffers and reading existing
" release note files
"
au BufNewFile,BufRead release.notes set filetype=cmtreln 
au BufNewFile release.notes call <SID>CmtRelNoteHeader()
au BufRead,BufNewFile release.notes setlocal shiftwidth=3 
au BufRead,BufNewFile release.notes setlocal tabstop=3 
au BufRead,BufNewFile release.notes setlocal expandtab 
au BufRead,BufNewFile release.notes setlocal textwidth=78 
au BufRead,BufNewFile release.notes setlocal smartindent
au BufReadPost    release.notes %retab 


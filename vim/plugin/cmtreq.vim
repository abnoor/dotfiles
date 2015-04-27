"
" Maintainer:   Kurt Rinnert <kurt.rinnert@cern.ch>
" Last Change:  Sun Aug 20 19:07:27 BST 2006
"
" DESCRIPTION:
"   Sets filetype upon buffer creation or reading, thereby enabling the
"   requirements file syntax highlighting. Also triggers insertion of a header
"   template if a new requiremnents file is created.  Makes some helpful
"   settings for tab and indenting as well.
"   
"   Enjoy, and happy vimming!
"

"
" bail out if already loaded or compatibility mode is set
"
if exists("loaded_cmtreq") || &cp
  finish
endif

"
" functions to be executed when a requirements file is
" created
"
function! <SID>CmtRequirementsHeader()
    call append(line("$")-1,'#============================================================================')
    call append(line("$")-1,'# Created    : '.strftime("%Y-%m-%d"))
    if exists("g:userEMail")
      call append(line("$")-1,'# Maintainer : '.g:userFullName.' <'.g:userEMail.'>')
    else
      call append(line("$")-1,'# Maintainer : '.g:userFullName)
    endif
    call append(line("$")-1,'')
    call append(line("$")-1,'# Documentation on the requirement file can be found at')
    call append(line("$")-1,'# http://cern.ch/lhcb-comp/Support/html/new_structure.pdf')
    call append(line("$")-1,'#============================================================================')
    call append(line("$")-1,'')
endfunction

"
" mapping of file names to file types
"
au! BufNewFile,BufRead requirements        set filetype=cmtreq

"
" mapping to function calls for new buffers and reading existing
" requirements files
"
au BufRead,BufNewFile requirements setlocal shiftwidth=2 
au BufRead,BufNewFile requirements setlocal tabstop=2 
au BufRead,BufNewFile requirements setlocal expandtab 
au BufRead,BufNewFile requirements setlocal textwidth=77 
au BufRead,BufNewFile requirements setlocal smartindent
au BufNewFile requirements call <SID>CmtRequirementsHeader()
au BufReadPost requirements %retab



"
" Maintainer:   Kurt Rinnert <kurt.rinnert@cern.ch>
" Last Change:  Sat Aug 19 21:02:49 BST 2006
"
" DESCRIPTION:
"   Some commands for working with CMT release notes.
"
"   When a new release.note file is created, the necessary header
"   template is automatically inserted.
"
"   In addition there are two commands for helping you editing your release
"   notes.  CmtRelNote creates a new note entry and CmtRelTag <tag> creates a
"   new release tag line.  The <tag> argument has to be of the format v<n>r<m>
"   or v<i>r<j>p<k>.  You can specify a tag with a different format, the
"   command will still work.  The fact the it is not syntax highlighted will
"   tell you that you did it wrong. 
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
" check whether this buffer actually is a release notes file
"
function! <SID>CmtIsRelNoteFile()
  let l:file_name = expand("%:t")
	if l:file_name == 'release.notes'
		return 1
	else
		return 0
	endif
endfunction

"
" get the package name from the file header
"
function! <SID>CmtGetPackageName()
  let l:lnum = 1
  while l:lnum <= line('$')
    let l:current_line = getline(l:lnum)
    let l:is_pack_line = match(l:current_line,'^!\s*Package\s*:\s*')
    if l:is_pack_line >= 0
      let l:pack = substitute(l:current_line,'^!\s*Package\s*:\s*','','')
      let l:pack = substitute(l:pack,'\s*$','','')
      let l:pack = substitute(l:pack,'^.*/','','g')
      break
    endif
    let l:lnum = l:lnum + 1
  endwhile
  return l:pack
endfunction

"
" where to insert a new release tag line or release note
"
function! <SID>CmtFindInsertLine()
  "
  " where to insert it?
  "   
  let l:lnum = 1
  while l:lnum <= line('$')
    let l:current_line = getline(l:lnum)
    let l:is_reln_line = match(l:current_line,'^!\s*[[:digit:]]\{4}-[[:digit:]]\{2}-[[:digit:]]\{2}\s\+-\s\+\|^!=\+')
    if l:is_reln_line >= 0
      break
    endif
    let l:lnum = l:lnum + 1
  endwhile
	return l:lnum-1
endfunction

"
" trim all release tag lines
"
function! <SID>CmtTrimAllTagLines()
  let l:lnum = 1
  while l:lnum <= line('$')
    let l:current_line = getline(l:lnum)
    let l:is_tag = match(l:current_line,'^!\s*=\+')
    if l:is_tag >= 0
      call <SID>CmtTrimTagLine(l:lnum)
    endif
    let l:lnum = l:lnum + 1
  endwhile
endfunction

"
" trim a line assuming it is a release tag
"
function! <SID>CmtTrimTagLine(tag_line_num)
  let l:tag_line        = getline(a:tag_line_num)
  let l:tag_line = substitute(l:tag_line,'=*\s*=*\s*$','','')
  let l:tag_line = substitute(l:tag_line,'^\s*!\s*=*','','')
  let l:tag_line_length = strlen(l:tag_line)+2
  if l:tag_line_length >= 78
    let l:tag_line = substitute(l:tag_line,'^','!=','')
    let l:tag_line = substitute(l:tag_line,'$','=','')
    call setline(a:tag_line_num,l:tag_line)
    return
  endif
  let l:n_fill_start = (78 - l:tag_line_length)/2
  if ((78 - l:tag_line_length)/2)*2 < (78 - l:tag_line_length)
    let l:n_fill_start = l:n_fill_start + 1
  endif
  let l:n_fill_end = (78 - l:tag_line_length)/2 
  let l:fill_start = '!'.repeat('=',l:n_fill_start)
  let l:fill_end = ' '.repeat('=',l:n_fill_end)
  let l:tag_line = substitute(l:tag_line,'^',l:fill_start,'')
  let l:tag_line = substitute(l:tag_line,'$',l:fill_end,'')
  call setline(a:tag_line_num,l:tag_line)
endfunction

"
" insert new release note
"
function! <SID>CmtRelNoteImp()
	if !<SID>CmtIsRelNoteFile()
		return
	endif
  let l:current_date = strftime("%Y-%m-%d")
	let l:lnum = <SID>CmtFindInsertLine()
	call append(l:lnum,'')
	call append(l:lnum,' - ')
	call append(l:lnum,'! '.l:current_date.' - '.g:userFullName)
	call cursor(l:lnum+2,4)
	startinsert!
endfunctio

"
" insert new release tag line
"
function! <SID>CmtRelTagImp(tag)
	if !<SID>CmtIsRelNoteFile()
		return
	endif
  let l:package      = <SID>CmtGetPackageName()
  let l:current_date = strftime("%Y-%m-%d")
  let l:tag_line     = '!==== '.l:package.' '.a:tag.' '.l:current_date.' ===='
	let l:lnum = <SID>CmtFindInsertLine()
  call append(l:lnum,l:tag_line)
  call  <SID>CmtTrimAllTagLines()
endfunctio

"
" user visible command definitions
"
command! -nargs=1 CmtRelTag       :call <SID>CmtRelTagImp("<args>")
command! -nargs=0 CmtRelNote      :call <SID>CmtRelNoteImp()


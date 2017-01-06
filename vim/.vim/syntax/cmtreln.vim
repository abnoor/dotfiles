"
" Maintainer: 	Kurt Rinnert <kurt.rinnert@cern.ch>
" Last Change:	Sat Aug 19 21:13:12 BST 2006
"
" DESCRIPTION:
" 	Syntax file for CMT release notes
"

" Quit when a (custom) syntax file was already loaded
if exists("b:current_syntax")
	finish
endif

syntax clear
syntax case match

" keywords
syn keyword cmtrelnHeaderTag Package Responsible Purpose contained

" contained dmatches
syn match cmtrelnDate /[0-9]\{4}-[0-9]\{2}-[0-9]\{2}/ contained
syn match cmtrelnName /\s\+-\s\+.*/ms=s+3 contained
syn match cmtrelnTag /[[:alnum:]]\+ v[[:digit:]]\+r[[:digit:]]\+p[[:digit:]]\+\|[[:alnum:]]\+ v[[:digit:]]\+r[[:digit:]]\+/ contained

" matches
syn match cmtrelnComment /^!.*$/ contains=cmtrelnName,cmtrelnHeaderTag,cmtrelnDate,cmtrelnTag
syn match cmtrelnNoteDash /^ - / 

" highlight color links 
hi def link cmtrelnComment		Comment
hi def link cmtrelnHeaderTag Include
hi def link cmtrelnName      Type
hi def link cmtrelnDate      Statement
hi def link cmtrelnTag       String
hi def link cmtrelnNotedash  String

let b:current_syntax = "cmtreln"

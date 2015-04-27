" Vim tools for C++, templates
"
" Maintainer:   Kurt Rinnert <kurt.rinnert@cern.ch>
" Last Change:  Sat Aug 19 12:45:59 BST 2006
"
" DESCRIPTION:
"   This plugin provides some templates for C++ developers.
"
"   The probably most frequently used is a template for simple C++ classes,
"   not inheriting from anything.  The command is called 'CppClass'.   Whether
"   a header (class declaration) template or an implementation file template
"   is created depends on the file extension of the current buffer.  Accepted
"   extensions are .h, .hh, .hxx and .hpp as header file extensions and .cc,
"   .cpp and .cxx as implementation file extensions.  
"
"   There is also template for a simple main program.  This is intended for
"   speeding up the creation of quick hack programs.  Mostly useful for
"   checking implementation details of your C++/STL implementation or quickly
"   trying out something in general.  The command is CppMain.  It works in
"   buffers with accepted implementation file extensions (see above).
"
"   Note that the header file extension used in the include directive of the
"   implementation file is always the file extension of the last buffer for
"   which a header template was created!  If no header template was created in
"   the current vim session, the extension defaults to .h.  This approach
"   seems reasonable since it is unlikely that the file name convention varies
"   inside one project.  Also creating a header file and the implementation
"   directly afterwards seems the most likely use case.  If in some case that
"   is not what you want the preprocessor will most likely tell you and you'll
"   have to edit the include directive in the implementation file.
"   
"   Enjoy, and happy vimming!
"

"
" bail out if already loaded or compatibility mode is set
"
if exists("loaded_cpp_tl") || &cp
	finish
endif

"
" keep track of the last header extension
"
let s:last_header_ext = 'h'

"
" hide one half of the rcs id pattern, otherwise
" cvs will insert the version information in
" the template
"
let s:rcsid_tag = '$ID:'

"
" buffer, user and date information common to all functions
"
function! <SID>GetInfo()
	"
  " get classname and file extension from file name
  " of current buffer
  "
  let s:file_ext         = expand("%:e")
	let s:upper_file_ext   = toupper(s:file_ext)
  let s:file_name        = expand("%:t")
  let s:class_name       = expand("%:t:r")
  let s:upper_class_name = toupper(s:class_name)
	let s:prg_name         = s:class_name
	let s:upper_prg_name   = s:upper_class_name
  "
  " retrieve user and date information from system
  "
  let s:current_date     = strftime("%Y-%m-%d")
endfunction

"
" where to put the cursor after inserting a header template
" (in the line after the one containing the Doxygen @class tag)  
"
function! <SID>HeaderTLSetPos()
  "
  " where to move?
  "   
  let l:lnum = 1
  while l:lnum <= line('$')
    let l:current_line = getline(l:lnum)
    let l:is_reln_line = match(l:current_line,'^/\*\* @class.*')
    if l:is_reln_line >= 0
			call cursor (l:lnum+1,4)
      return
    endif
    let l:lnum = l:lnum + 1
  endwhile
	call cursor(1,1)
endfunction

"
" simple C++ class template
"
function! <SID>CppClassImp()

	call <SID>GetInfo()

  "
  " header template for simple C++ class
  "
  if s:file_ext == 'h' || s:file_ext == 'hh' || s:file_ext == 'hpp' || s:file_ext == 'hxx'
		let s:last_header_ext = s:file_ext
    call append(line("$")-1,'// '.s:rcsid_tag.' $')
    call append(line("$")-1,'#ifndef INCLUDE_'.s:upper_class_name.'_'.s:upper_file_ext)
    call append(line("$")-1,'#define INCLUDE_'.s:upper_class_name.'_'.s:upper_file_ext.' 1')
    call append(line("$")-1,'')
    call append(line("$")-1,'')
    call append(line("$")-1,'/** @class '.s:class_name.' '.s:file_name)
    call append(line("$")-1,' *  ')
    call append(line("$")-1,' *')
		if exists("g:userEMail")
    	call append(line("$")-1,' * @author '.g:userFullName.' <'.g:userEMail.'>')
		else
    	call append(line("$")-1,' * @author '.g:userFullName)
		endif
    call append(line("$")-1,' * @date   '.s:current_date)
    call append(line("$")-1,' */')
    call append(line("$")-1,'class '.s:class_name.' {' ) 
    call append(line("$")-1,'')
    call append(line("$")-1,'public:')
    call append(line("$")-1,'')
		call append(line("$")-1,'  /// Standard Constructor')
		call append(line("$")-1,'  '.s:class_name.'();')
    call append(line("$")-1,'')
    call append(line("$")-1,'  ~'.s:class_name.'(); ///< Destructor')
    call append(line("$")-1,'')
    call append(line("$")-1,'protected:')
    call append(line("$")-1,'')
    call append(line("$")-1,'')
    call append(line("$")-1,'private:')
    call append(line("$")-1,'')
    call append(line("$")-1,'')
    call append(line("$")-1,'};')
    call append(line("$")-1,'#endif // INCLUDE_'.s:upper_class_name.'_'.s:upper_file_ext)

		call <SID>HeaderTLSetPos()
  " 
  " implementation template for simple C++ class
  "
  elseif s:file_ext == 'cpp' || s:file_ext == 'cc' || s:file_ext == 'cxx'
    call append(line("$")-1,'// '.s:rcsid_tag.' $')
    call append(line("$")-1,'')
    call append(line("$")-1,'#include "'.s:class_name .'.'.s:last_header_ext.'"')
    call append(line("$")-1,'')
    call append(line("$")-1,'')
    call append(line("$")-1,'//-----------------------------------------------------------------------------')
    call append(line("$")-1,'// Implementation file for class : '.s:class_name)
    call append(line("$")-1,'//')
		if exists("g:userEMail")
    	call append(line("$")-1,'// '. s:current_date.' : '.g:userFullName.' <'.g:userEMail.'>')
		else
    	call append(line("$")-1,'// '. s:current_date.' : '.g:userFullName)
		endif
    call append(line("$")-1,'//-----------------------------------------------------------------------------')
    call append(line("$")-1,'')
    call append(line("$")-1,'')
    call append(line("$")-1,'')
    call append(line("$")-1,'//=============================================================================')
    call append(line("$")-1,'// Standard constructor, initializes variables')
		call append(line("$")-1,'//=============================================================================')
		call append(line("$")-1,s:class_name.'::'.s:class_name.'()')
    call append(line("$")-1,'{')
		call append(line("$")-1,'  ;')
		call append(line("$")-1,'}')
    call append(line("$")-1,'')
    call append(line("$")-1,'//=============================================================================')
    call append(line("$")-1,'// Destructor')
    call append(line("$")-1,'//=============================================================================')
    call append(line("$")-1,s:class_name.'::~'.s:class_name.'() {;}')
    call append(line("$")-1,'')

		call cursor(1,1)
  endif
endfunction

"
" where to put the cursor after inserting a main() template
" (two lines after the start of the main() declaration)  
"
function! <SID>MainTLSetPos()
  "
  " where to move?
  "   
  let l:lnum = 1
  while l:lnum <= line('$')
    let l:current_line = getline(l:lnum)
    let l:is_reln_line = match(l:current_line,'^int main(.*')
    if l:is_reln_line >= 0
			call cursor (l:lnum+2,2)
      return
    endif
    let l:lnum = l:lnum + 1
  endwhile
	call cursor(1,1)
endfunction

"
" simple main program template
"
function! <SID>CppMainImp()

	call <SID>GetInfo()

	"
	" template is only created for accepted implementation
	" file extensions
	"
	if s:file_ext == 'cpp' || s:file_ext == 'cc' || s:file_ext == 'cxx'
    call append(line("$")-1,'// '.s:rcsid_tag.' $')
    call append(line("$")-1,'')
    call append(line("$")-1,'#include <iostream>')
    call append(line("$")-1,'#include <sstream>')
    call append(line("$")-1,'#include <string>')
    call append(line("$")-1,'#include <vector>')
    call append(line("$")-1,'#include <map>')
    call append(line("$")-1,'#include <list>')
    call append(line("$")-1,'#include <algorithm>')
    call append(line("$")-1,'')
    call append(line("$")-1,'#include <string.h>')
    call append(line("$")-1,'#include <stdio.h>')
    call append(line("$")-1,'#include <math.h>')
    call append(line("$")-1,'')
    call append(line("$")-1,'// user includes go here')
    call append(line("$")-1,'')
    call append(line("$")-1,'')
    call append(line("$")-1,'using namespace std;')
    call append(line("$")-1,'')
    call append(line("$")-1,'//-----------------------------------------------------------------------------')
    call append(line("$")-1,'// Implementation of main() for program : '.s:prg_name)
    call append(line("$")-1,'//')
		if exists("g:userEMail")
    	call append(line("$")-1,'// '. s:current_date.' : '.g:userFullName.' <'.g:userEMail.'>')
		else
    	call append(line("$")-1,'// '. s:current_date.' : '.g:userFullName)
		endif
    call append(line("$")-1,'//-----------------------------------------------------------------------------')
    call append(line("$")-1,'')
    call append(line("$")-1,'int main(int argc, char* argv[])')
    call append(line("$")-1,'{')
    call append(line("$")-1,'  ')
    call append(line("$")-1,'')
    call append(line("$")-1,'  return 0;')
    call append(line("$")-1,'}')
    call append(line("$")-1,'')

		call <SID>MainTLSetPos()
	endif
endfunction

"
" the template commands
"
command! -nargs=0 CppClass       :call <SID>CppClassImp()
command! -nargs=0 CppMain        :call <SID>CppMainImp()



" Vim tools for Gaudi, templates
"
" Maintainer:   Kurt Rinnert <kurt.rinnert@cern.ch>
" Hacker:       Karol Hennessy <karol.hennessy@cern.ch>
" Last Change:  Sat Aug 19 12:48:31 BST 2006 
"
" DESCRIPTION:
"   Provides functions and user defined commands to create source code
"   templates useful for software development in the Gaudi framework.
"
"   As opposed to e.g. the somewhat patronizing LHCb emacs mode these tools
"   and templates do not interfere with your editing sessions outside the
"   Gaudi framework, even when they are loaded.  Nothing magic will happen
"   automatically when you open a file with a specific extension -- you decide
"   what what you want to do!  
"
"   If you decide to implement a new GaudiAlgorithm, you open the .h or .cpp
"   file as usual.  Nothing happens, no questions asked.  Since *you* know
"   that you are about to implement a GaudiAlgorithm you invoke
"   ':GaudiAlgorithm' and the correct template will be chosen based on the
"   file name extension of the current buffer.  If the extension is not either
"   .h or .cpp nothing will happen.  Same procedure for other base classes
"   like GaudiTool and so on.  
"
"   Tab completion works on all commands so it's always easy to find out
"   whether a template for your favourite base class is available. 
"
"   Enjoy, and happy vimming!
"

"
" bail out if already loaded or compatibility mode is set
"
if exists("loaded_cpp_gauditl") || &cp
	finish
endif

"
" hide one half of the rcs id pattern, otherwise
" cvs will insert the version information in
" the template
"
let s:rcsid_tag = '$ID:'

"
" buffer and date information common to all functions
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
" template insertion function
"
function! <SID>GaudiBaseImp (base_class)

  call <SID>GetInfo()

  "
  " Tool or Alg?
  "
  if a:base_class =~ '\<Gaudi.*Alg.*\>'
    let class_type = 'Algorithm'
  elseif a:base_class =~ '\<Gaudi.*Tool\>'
    let class_type = 'Tool'
  elseif a:base_class =~ '\<DV.*\>'
    let class_type = 'DVAlgorithm'
  endif

  "
  " identifier names used in templates, stored in 
  " variables to ensure consistency of header and
  " implementation templates
  "
  let type_ident       = 'type'
  let name_ident       = 'name'
  let locator_ident    = 'pSvcLocator'
  let if_ident         = 'parent'

  "
  " header template for Algs and Tools
  "
  if s:file_ext == 'h'
    call append(line("$")-1,'// '.s:rcsid_tag.' $')
    call append(line("$")-1,'#ifndef INCLUDE_'.s:upper_class_name.'_H')
    call append(line("$")-1,'#define INCLUDE_'.s:upper_class_name.'_H 1')
    call append(line("$")-1,'')
    if l:class_type == 'Algorithm' || l:class_type == 'Tool'
      call append(line("$")-1,'#include "GaudiAlg/'.a:base_class.'.h"')
    elseif l:class_type == 'DVAlgorithm'
      call append(line("$")-1,'#include "Kernel/'.a:base_class.'.h"')
    endif
    call append(line("$")-1,'')
    call append(line("$")-1,'')
    if l:class_type == 'Tool'
      call append(line("$")-1,'static const InterfaceID IID_'.s:class_name.'("'.s:class_name.'", 1, 0);')
      call append(line("$")-1,'')
    endif
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
    call append(line("$")-1,'class '.s:class_name.' : public '.a:base_class.' {' ) 
    call append(line("$")-1,'')
    call append(line("$")-1,'public:')
    call append(line("$")-1,'')
    if l:class_type == 'Tool'
      call append(line("$")-1,'  // Return the interface ID')
      call append(line("$")-1,'  static const InterfaceID& interfaceID() { return IID_PatCounter; }')
      call append(line("$")-1,'')
    endif
    call append(line("$")-1,'  /// Standard Constructor')
    if l:class_type == 'Algorithm' || l:class_type == 'DVAlgorithm'
      call append(line("$")-1,'  '.s:class_name.'(const std::string& '.l:name_ident.', ISvcLocator* '.l:locator_ident.');')
    elseif l:class_type == 'Tool'
      call append(line("$")-1,'  '.s:class_name .'(const std::string& '.l:type_ident.',')
      call append(line("$")-1,'  '.repeat(' ',strlen(s:class_name)+1).'const std::string& '.l:name_ident.',')
      call append(line("$")-1,'  '.repeat(' ',strlen(s:class_name)+1).'const IInterface* '.l:if_ident.');')
    endif 
    call append(line("$")-1,'')
    call append(line("$")-1,'  virtual ~'.s:class_name.'(); ///< Destructor')
    call append(line("$")-1,'')
    call append(line("$")-1,'  virtual StatusCode initialize(); ///< '.l:class_type.' initialization')
    if l:class_type == 'Algorithm' || l:class_type == 'DVAlgorithm'
      call append(line("$")-1,'  virtual StatusCode    execute(); ///< '.l:class_type.' event execution')
    endif
    call append(line("$")-1,'  virtual StatusCode   finalize(); ///< '.l:class_type.' finalize')
    call append(line("$")-1,'')
    call append(line("$")-1,'protected:')
    call append(line("$")-1,'')
    call append(line("$")-1,'')
    call append(line("$")-1,'private:')
    call append(line("$")-1,'')
    call append(line("$")-1,'')
    call append(line("$")-1,'};')
    call append(line("$")-1,'#endif // INCLUDE_'.s:upper_class_name.'_H')

		call <SID>HeaderTLSetPos()
  " 
  " implementation template for Algs and Tools
  "
  elseif s:file_ext == 'cpp'
    call append(line("$")-1,'// '.s:rcsid_tag.' $')
    if l:class_type == 'Algorithm'
      call append(line("$")-1,'#include "GaudiKernel/AlgFactory.h"')
    elseif l:class_type == 'Tool'
      call append(line("$")-1,'#include "GaudiKernel/ToolFactory.h"')
      call append(line("$")-1,'#include "GaudiKernel/IRegistry.h"')
    elseif l:class_type == 'DVAlgorithm'
      call append(line("$")-1,'#include "GaudiKernel/DeclareFactoryEntries.h"')
    endif
    call append(line("$")-1,'')
    call append(line("$")-1,'#include "'.s:class_name .'.h"')
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
    if l:class_type == 'Algorithm'
      call append(line("$")-1,'// Declaration of the Algorithm Factory')
      call append(line("$")-1,'static const AlgFactory<'.s:class_name.'>           s_factory;')
      call append(line("$")-1,'const        IAlgFactory& '.s:class_name.'Factory = s_factory;')
    elseif l:class_type == 'Tool'
      call append(line("$")-1,'static const ToolFactory<'.s:class_name.'>           s_factory;')
      call append(line("$")-1,'const        IToolFactory& '.s:class_name.'Factory = s_factory;')
    elseif l:class_type == 'DVAlgorithm'
      call append(line("$")-1,'DECLARE_ALGORITHM_FACTORY( '.s:class_name.' );')
    endif
    call append(line("$")-1,'')
    call append(line("$")-1,'')
    call append(line("$")-1,'//=============================================================================')
    call append(line("$")-1,'// Standard constructor, initializes variables')
    call append(line("$")-1,'//=============================================================================')
    if l:class_type == 'Algorithm' || l:class_type == 'DVAlgorithm'
      call append(line("$")-1,s:class_name.'::'.s:class_name.'(const std::string& '.l:name_ident.', ISvcLocator* '.l:locator_ident.')')
      call append(line("$")-1,'  : '.a:base_class.'('.l:name_ident.', '.l:locator_ident.')')
    elseif l:class_type == 'Tool'
      call append(line("$")-1,s:class_name .'::'.s:class_name .'(const std::string& '.l:type_ident.',')
      call append(line("$")-1,repeat(' ',strlen(s:class_name)*2+3).'const std::string& '.l:name_ident.',')
      call append(line("$")-1,repeat(' ',strlen(s:class_name)*2+3).'const IInterface* '.l:if_ident.');')
      call append(line("$")-1,'  : '.a:base_class.'('.l:type_ident.', '.l:name_ident.', '.l:if_ident.')')
    endif 
    call append(line("$")-1,'{')
    if l:class_type == 'Algorithm'  || l:class_type == 'DVAlgorithm'
      call append(line("$")-1,'  ;')
    elseif l:class_type == 'Tool'
      call append(line("$")-1,'  declareInterface<'.s:class_name.'>(this);')
    endif
    call append(line("$")-1,'}')
    call append(line("$")-1,'')
    call append(line("$")-1,'//=============================================================================')
    call append(line("$")-1,'// Destructor')
    call append(line("$")-1,'//=============================================================================')
    call append(line("$")-1,s:class_name.'::~'.s:class_name.'() {;}')
    call append(line("$")-1,'')
    call append(line("$")-1,'//=============================================================================')
    call append(line("$")-1,'// Initialization')
    call append(line("$")-1,'//=============================================================================')
    call append(line("$")-1,'StatusCode '.s:class_name.'::initialize()')
    call append(line("$")-1,'{')
    call append(line("$")-1,'  StatusCode sc = '.a:base_class.'::initialize(); // must be executed first')
    call append(line("$")-1,'  if (sc.isFailure()) return sc;  // error printed already by '.a:base_class)
    call append(line("$")-1,'')
    call append(line("$")-1,'  debug() << "==> Initialize" << endmsg;')
    call append(line("$")-1,'')
    call append(line("$")-1,'')
    call append(line("$")-1,'  return StatusCode::SUCCESS;')
    call append(line("$")-1,'}')
    if l:class_type == 'Algorithm' || l:class_type == 'DVAlgorithm'
      call append(line("$")-1,'')
      call append(line("$")-1,'//=============================================================================')
      call append(line("$")-1,'// Main execution')
      call append(line("$")-1,'//=============================================================================')
      call append(line("$")-1,'StatusCode '.s:class_name.'::execute()')
      call append(line("$")-1,'{')
      call append(line("$")-1,'  debug() << "==> Execute" << endmsg;')
      call append(line("$")-1,'')
      if l:class_type == 'DVAlgorithm'
        call append(line("$")-1,'  setFilterPassed(true);   // Mandatory. Set to true if event is accepted.')
      endif
      call append(line("$")-1,'')
      call append(line("$")-1,'  return StatusCode::SUCCESS;')
      call append(line("$")-1,'}')
    endif
    call append(line("$")-1,'')
    call append(line("$")-1,'//=============================================================================')
    call append(line("$")-1,'// Finalize')
    call append(line("$")-1,'//=============================================================================')
    call append(line("$")-1,'StatusCode '.s:class_name.'::finalize()')
    call append(line("$")-1,'{')
    call append(line("$")-1,'  debug() << "==> Finalize" << endmsg;')
    call append(line("$")-1,'')
    call append(line("$")-1,'')
    call append(line("$")-1,'  return '.a:base_class.'::finalize();  // must be called after all other actions')
    call append(line("$")-1,'}')
    call append(line("$")-1,'')

		call cursor(1,1)
  endif
endfunction

"
" base class specific wrapper functions
"
function! <SID>GaudiAlgorithmImp()
  call <SID>GaudiBaseImp("GaudiAlgorithm")
endfunction

function! <SID>GaudiHistoAlgImp()
  call <SID>GaudiBaseImp("GaudiHistoAlg")
endfunction

function! <SID>GaudiTupleAlgImp()
  call <SID>GaudiBaseImp("GaudiTupleAlg")
endfunction

function! <SID>GaudiToolImp()
  call <SID>GaudiBaseImp("GaudiTool")
endfunction

function! <SID>GaudiHistoToolImp()
  call <SID>GaudiBaseImp("GaudiHistoTool")
endfunction

function! <SID>GaudiTupleToolImp()
  call <SID>GaudiBaseImp("GaudiTupleTool")
endfunction

function! <SID>DVAlgorithmImp()
  call <SID>GaudiBaseImp("DVAlgorithm")
endfunction

"
" the template commands
"
command! -nargs=0 GaudiAlgorithm :call <SID>GaudiAlgorithmImp()
command! -nargs=0 GaudiHistoAlg  :call <SID>GaudiHistoAlgImp()
command! -nargs=0 GaudiTupleAlg  :call <SID>GaudiTupleAlgImp()
command! -nargs=0 GaudiTool      :call <SID>GaudiToolImp()
command! -nargs=0 GaudiHistoTool :call <SID>GaudiHistoToolImp()
command! -nargs=0 GaudiTupleTool :call <SID>GaudiTupleToolImp()
command! -nargs=0 DVAlgorithm    :call <SID>DVAlgorithmImp()



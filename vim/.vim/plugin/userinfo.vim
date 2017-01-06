"
" Maintainer:   Kurt Rinnert <kurt.rinnert@cern.ch>
" Last Change:  Sat Aug 19 14:53:39 BST 2006
"
" DESCRIPTION:
"   Determines the full user name from the finger command and a little pipe
"   and cut on Linux.  Might also work on other *ix platforms (untested and
"   currently not supported, reports welcome).
"
"   If the global variable userFullName is set this plugin does nothing.  This
"   allows to easily make the template system work on platforms not supported
"   by this plugin.  To do that you have to add this to your .vimrc:
"
"     let g:userFullName = '<your full user name>'
"     let g:userEMail    = '<your email address>'
"
"   The setting of the email address is optional.  It will not be set by this
"   plugin, even if g:fullUserName is unset!
"
"   Enjoy, and happy vimming!
"

"
" bail out if already loaded, compatibility mode is set or the user's
" full name is already specified
"
if exists("loaded_cpptl") || &cp || exists("g:userFullName")
	finish
endif


"
" retrieve full user name from system (Linux only)
"
let g:userFullName   = system("finger -l `whoami` | head -n 1 | cut -s -d : -f 3")
let g:userFullName   = strpart(g:userFullName,1,strlen(g:userFullName)-2)

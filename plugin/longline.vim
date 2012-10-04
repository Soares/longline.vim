" longline.vim - Avoid long lines.
"
" Author:       Nate Soares <http://so8r.es>
" Version:      1.1
" License:      The same as vim itself. (See |license|)
" GetLatestVimScripts: 4246 1 :AutoInstall: terminus.zip

if exists('g:loaded_longline') || &cp || v:version < 700
	finish
endif
let g:loaded_longline = 1


" Commands:
command! LongLineHide call longline#Hide()
command! LongLineShow call longline#Show()
command! LongLineToggle call longline#Toggle()
command! LongLineNext call longline#Next()
command! LongLinePrev call longline#Prev()


" Whether or not to automatically adjust the shiftwidth.
if !exists('g:longline_autotw')
	let g:longline_autotw = 1
endif

" Whether or not to automatically highlight long lines.
if !exists('g:longline_autohl')
	let g:longline_autohl = 0
endif

" What to match long lines with.
if !exists('g:longline_matchgroup')
	let g:longline_matchgroup = 'ErrorMsg'
endif

" How long is 'too long'.
if !exists('g:longline_maxlength')
	let g:longline_maxlength = 80
endif

" Filetypes that don't conform to the default 'too long' rule.
" Will be extended with defaults when the script is autoloaded.
if !exists('g:longline_default_exceptions')
	let g:longline_default_exceptions = {'text': 0, 'html': 0, 'help': 78}
endif

" Filetypes that don't conform to the default 'too long' rule.
" Will be extended with defaults when the script is autoloaded.
if !exists('g:longline_exceptions')
	let g:longline_exceptions = {}
endif

" Extend the exceptions with the default exceptions.
call extend(g:longline_exceptions, g:longline_default_exceptions, 'keep')

" A dictionary of filetype => whether text should be wrapped.
" By default, if longline#MaxLength is non-zero text will be wrapped.
" Use this dictionary to override that behavior one way or the other.
" A value <= 0 indicates that text should not be wrapped.
" Will be extended with deaults when the script is autoloaded.
if !exists('g:longline_tw')
	let g:longline_tw = {}
endif


augroup longline
	" Clears existing longline autocmds
	autocmd!
augroup end


" Automatically wrap text.
if g:longline_autotw
	augroup longline
		autocmd BufEnter ?* if longline#WrapText()
					\| let &l:tw=longline#MaxLength()
					\| endif
	augroup end
endif


" Automatically highlight long lines.
if g:longline_autohl
	augroup longline
		autocmd BufEnter * ShowLongLines
	augroup end
endif

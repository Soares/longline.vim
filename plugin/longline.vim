" longline.vim - Avoid long lines.
" Author:       Nate Soares <http://so8r.es>
" Version:      1.1.1
" License:      The same as vim itself. (See |license|)
" GetLatestVimScripts: 4246 1 :AutoInstall: terminus.zip

if exists('g:loaded_longline') || &cp || v:version < 700
	finish
endif
let g:loaded_longline = 1


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
if !exists('g:longline_exceptions')
	let g:longline_exceptions = {}
endif


" A list of filetypes that should never have 'textwrap' set by longline.
if !exists('g:longline_noautotw')
	let g:longline_noautotw = []
endif


" Whether or not to make the default key mappings.
if !exists('g:longline_automap')
	let g:longline_automap = 0
endif


" Extend the exceptions with the default exceptions.
call extend(g:longline_exceptions, g:longline_default_exceptions, 'keep')


" Commands:
command! LongLineHide call longline#hide()
command! LongLineShow call longline#show()
command! LongLineToggle call longline#toggle()
command! LongLineNext call longline#next()
command! LongLinePrev call longline#prev()


" Clear existing longline autocmds
augroup longline
	autocmd!
augroup end


" Automatically wrap text.
if g:longline_autotw
	augroup longline
		autocmd BufEnter ?*
				\	if longline#wraptext()
				\|		let &l:tw=longline#maxlength()
				\|	endif
	augroup end
endif


" Automatically highlight long lines.
if g:longline_autohl
	augroup longline
		autocmd BufEnter * LongLineShow
	augroup end
endif


" Enable the default key mappings.
if g:longline_automap
	noremap <leader>ll :LongLineToggle<CR>
	noremap <leader>ln :LongLineNext<CR>
	noremap <leader>lp :LongLinePrev<CR>
endif

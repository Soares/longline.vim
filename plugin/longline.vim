" longline.vim - Avoid long lines.
" Author:       Nate Soares <http://so8r.es>
" Version:      2.1.0
" License:      The same as vim itself. (See |license|)
" GetLatestVimScripts: 4246 1 :AutoInstall: terminus.zip

if exists('g:loaded_longline') || &cp || v:version < 700
	finish
endif
let g:loaded_longline = 1


" Which highlight group to match long lines with.
if !exists('g:longline_matchgroup')
	let g:longline_matchgroup = 'ErrorMsg'
endif


" Whether or not to define the LongLine commands.
if !exists('g:longline_defcmds')
	let g:longline_defcmds = 1
endif


" Whether or not to automatically highlight long lines.
if !exists('g:longline_autohl')
	let g:longline_autohl = 0
endif


" Whether or not to make the default key mappings.
if !exists('g:longline_automap')
	let g:longline_automap = 0
endif


" Commands:
if g:longline_defcmds
	command! LongLineHide call longline#hide()
	command! LongLineShow call longline#show()
	command! LongLineToggle call longline#toggle()
	command! LongLineNext call longline#next()
	command! LongLinePrev call longline#prev()
endif


" Clear existing longline autocmds
if g:longline_autohl
	augroup longline
		autocmd!
		autocmd BufEnter * call longline#show()
	augroup end
endif


" Make the default key mappings under <leader>l. Mnemonic: 'longline'.
" The leader letter can be configured via g:longline_automap.
if !empty(g:longline_automap)
	function! s:coerce(target, default)
		return type(a:target) == type(a:default) ? a:target : a:default
	endfunction
	let s:map = 'noremap <unique> <silent>'
	let s:prefix = '<leader>' . s:coerce(g:longline_automap, 'l')

	execute s:map s:prefix.'n :call longline#next()<CR>'
	execute s:map s:prefix.'p :call longline#prev()<CR>'
	execute s:map s:prefix.'l :call longline#toggle()<CR>'
	execute s:map s:prefix.'s :call longline#show()<CR>'
	execute s:map s:prefix.'h :call longline#hide()<CR>'
endif

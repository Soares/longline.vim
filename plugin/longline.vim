" longline.vim - Avoid long lines.
" Author:       Nate Soares <http://so8r.es>
" Version:      2.0.0
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


" Enable the default key mappings.
if g:longline_automap
	noremap <leader>ll :LongLineToggle<CR>
	noremap <leader>ln :LongLineNext<CR>
	noremap <leader>lp :LongLinePrev<CR>
endif

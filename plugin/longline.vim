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


" Autocommands:
augroup longline
	" Clears existing longline autocmds
	autocmd!
augroup end

" Automatically wrap text. On by default.
if !exists('g:longline#autotw') | let g:longline#autotw = 1 | endif
if g:longline#autotw
	augroup longline
		autocmd BufEnter ?* if longline#WrapText()
					\| let &l:tw=longline#MaxLength()
					\| endif
	augroup end
endif

" Automatically highlight long lines. Off by default.
if !exists('g:longline#autohl') | let g:longline#autohl = 0 | endif
if g:longline#autohl
	augroup longline
		autocmd BufEnter * ShowLongLines
	augroup end
endif

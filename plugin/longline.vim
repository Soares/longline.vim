" longline.vim - avoid long lines.
" Author:       Nate Soares <http://so8r.es>
" Version:      3.0.0
" License:      The same as vim itself. (See |license|)
" GetLatestVimScripts: 4246 1 :AutoInstall: terminus.zip

let g:loaded_longline = 1


" Which highlight group to match long lines with.
if !exists('g:longline_matchgroup')
	let g:longline_matchgroup = 'ErrorMsg'
endif

" Whether or not to automatically highlight long lines.
if !exists('g:longline_autohl')
	let g:longline_autohl = 0
endif

" Whether or not to make the default key mappings.
if !exists('g:longline_automap')
	let g:longline_automap = 0
endif

" Whether or not to make the default key mappings.
if !exists('g:longline_defcmds')
	let g:longline_defcmds = 1
endif


" Commands:
if g:longline_defcmds > 0
  if exists(':LongLine') == 2
    echomsg 'overwriting command :LongLine'
  endif
  " The arg may be any of: show, hide, toggle, next, prev(ious), and may be
  " empty. If empty, 'toggle' is used.
  command! -nargs=? LongLine call longline#run(<q-args>)
elseif g:longline_defcmds < 0
  if exists(':LongLine') == 2
    echomsg 'deleting command :LongLine'
    delcommand LongLine
  endif
endif


" Clear existing longline autocmds
if g:longline_autohl
	augroup longline
		autocmd!
		autocmd BufEnter * call longline#show()
	augroup end
endif

noremap <silent> <Plug>longline#next :call longline#next()<CR>
noremap <silent> <Plug>longline#prev :call longline#prev()<CR>
noremap <silent> <Plug>longline#toggle :call longline#toggle()<CR>
noremap <silent> <Plug>longline#show :call longline#show()<CR>
noremap <silent> <Plug>longline#hide :call longline#hide()<CR>

" Make the default key mappings under <leader>l. Mnemonic: 'longline'.
" The leader letter can be configured via g:longline_automap.
if g:longline_automap
	nmap <leader>ln <Plug>longline#next
	nmap <leader>lp <Plug>longline#prev
	nmap <leader>lt <Plug>longline#toggle
	nmap <leader>ls <Plug>longline#show
	nmap <leader>lh <Plug>longline#hide
endif

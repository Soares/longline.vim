if !exists('g:longline_matchgroup')
	let g:longline_matchgroup = 'ErrorMsg'
endif

if !exists('g:longline_maxlength')
	let g:longline_maxlength = 80
endif

if !exists('g:longline_filetype_map')
	let g:longline_filetype_map = {
				\ 'java':     100,
				\ 'html':      -1,
				\ 'soy':       -1,
				\ 'text':      -1,
				\ 'markdown':  -1,
				\ 'help':      -1,
				\}
endif


function! s:LineMatch(type, num)
	" Highlight lines of a certain length with a certain highlight group.
	exe "match ".a:type." '\\%>".a:num."v.\\+'"
endfunction


function! longline#MaxLength()
	let num = a:0 > 0 ? a:1 : 0
	if num == 0 | let num = get(g:longline_filetype_map, &ft) | endif
	if num == 0 | let num = g:longline_maxlength | endif
	if num < 1 | return -1 | endif
	return num
endfunction

function! longline#Show()
	" Highlight lines of or beyond a certain length.
	call longline#Hide()
	let num = call('longline#MaxLength', a:000)
	if num > 0
		call s:LineMatch(g:longline_matchgroup, num)
		let b:longline_highlighted = num
	endif
endfunction

function! longline#Exists()
	" True iff. a line exists that is too long.
	let num = call('longline#MaxLength', a:000)
	if num < 1 | return 0 | endif
	return search('\%>'.num.'v.', 'nw') != 0
endfunction

function! longline#Hide()
	" Remove the highlighting on long lines.
	if exists('b:longline_highlighted')
		if b:longline_highlighted > 0
			call s:LineMatch('NONE', b:longline_highlighted)
		endif
		unlet b:longline_highlighted
	endif
endfunction

function! longline#Toggle()
	" Toggle long line highlighting
	if exists('b:longline_highlighted') && b:longline_highlighted > 0
		call longline#Hide()
	else
		call call('longline#Show', a:000)
	endif
endfunction
command! LongLines call longline#Toggle()

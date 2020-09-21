function! longline#run(cmd) abort "{{{
	if a:cmd ==# 'show'
		call longline#show()
	elseif a:cmd ==# 'hide'
		call longline#hide()
	elseif a:cmd ==# 'toggle' || a:cmd ==# ''
		call longline#toggle()
	elseif a:cmd ==# 'next'
		call longline#next()
	elseif a:cmd ==# 'prev' || a:cmd ==# 'previous'
		call longline#prev()
	else
		echohl ErrorMsg
		echomsg "Unknown LongLine command:" a:cmd
		echohl None
	endif
endfunction "}}}

function! longline#complete(arglead, cmdline, cursorpos) abort "{{{
	return ['show', 'hide', 'toggle', 'next', 'prev', 'previous']
endfunction "}}}

" The regex for the nth column of a line.
" @param {number} num The column to search for.
" @return {string} The regex.
" @private
function! s:regex_col(num) "{{{
	return '\v%>'.a:num.'v'
endfunction "}}}


" Finds out whether a long line exists in the file.
" @param {number?} Max line width. Detected from filetype if ommited.
" @return {boolean} Whether or not a too-line long exists in the file.
function! longline#exists(...) abort "{{{
	let l:num = get(a:000, 0, &l:textwidth)
	if l:num <= 0 | return 0 | endif
	return search(s:regex_col(l:num+1), 'nw') != 0
endfunction "}}}


" Jumps the cursor to the next long line.
" @param {number?} Max line width. Detected from filetype if ommitted.
function! longline#next(...) abort "{{{
	let l:num = get(a:000, 0, &l:textwidth)
	call search(s:regex_col(l:num).'.+$', 'w')
endfunction "}}}


" Jumps the cursor to the previous long line.
" @param {number?} Max line width. Detected from filetype if ommitted.
function! longline#prev(...) abort "{{{
	let l:num = get(a:000, 0, &l:textwidth)
	call search(s:regex_col(l:num).'.+$', 'wb')
endfunction "}}}


" Removes the highlighting on long lines.
function! longline#hide() abort "{{{
	if exists('b:longline_match')
		try
			call matchdelete(b:longline_match)
		catch /E803:/
			" Do nothing
		endtry
		unlet b:longline_match
	endif
endfunction "}}}


" Highlights lines beyond a certain length.
" @param {number?} Max line width. Detected from filetype if ommitted.
function! longline#show(...) abort "{{{
	call longline#hide()
	let l:num = get(a:000, 0, &l:textwidth)
	if l:num > 0
		let l:regex = s:regex_col(l:num).'.+'
		let b:longline_match = matchadd(g:longline_matchgroup, l:regex)
	endif
endfunction "}}}


" Toggles long line highlighting
" @param {number?} Max line width. Detected from filetype if ommitted.
function! longline#toggle(...) abort "{{{
	if exists('b:longline_match')
		call longline#hide()
	else
		call call('longline#show', a:000)
	endif
endfunction "}}}

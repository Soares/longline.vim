" The regex for the nth column of a line.
" @param {number} num The column to search for.
" @return {string} The regex.
" @private
function! s:regex_col(num)
	return '\v%>'.a:num.'v'
endfunction


" The regex for the nth column of a line and everything thereafter.
" @param {number} num The column to search for.
" @return {string} The regex.
" @private
function! s:regex_all(num)
	return s:regex_col(num) . '.+'
endfunction


" Find the maximum allowable line length.
" @param {string?} Filetype to check the max length of. Default &ft.
" @return {number} The maximum allowable line length.
function! longline#maxlength(...)
	let l:ft = a:0 > 0 ? a:1 : &ft
	let l:num = get(g:longline_exceptions, l:ft, -1)
	if l:num == -1
		let l:num = g:longline_maxlength
	endif
	return l:num <= 0 ? 0 : l:num
endfunction


" Determines whether or not text should be wrapped.
" @param {string?} Filetype to check. Default &ft.
" @return {boolean} Whether or not text should be wrapped.
function! longline#wraptext(...)
	let l:ft = a:0 > 0 ? a:1 : &ft
	if index(g:longline_noautotw, l:ft) > -1
		return
	endif
	return longline#maxlength(l:ft) > 0
endfunction


" Finds out whether a long line exists in the file.
" @param {number?} Max line width. Detected from filetype if ommited.
" @return {boolean} Whether or not a too-line long exists in the file.
function! longline#exists(...)
	let l:num = a:0 > 0 ? a:1 : longline#maxlength()
	if l:num <= 0 | return 0 | endif
	return search(s:regex_col(l:num+1), 'nw') != 0
endfunction


" Jumps the cursor to the next long line.
" @param {number?} Max line width. Detected from filetype if ommitted.
function! longline#next(...)
	let l:num = a:0 > 1 ? a:1 : longline#maxlength()
	call search(s:regex_col(l:num).'.+$', 'w')
endfunction


" Jumps the cursor to the previous long line.
" @param {number?} Max line width. Detected from filetype if ommitted.
function! longline#prev(...)
	let l:num = a:0 > 1 ? a:1 : longline#maxlength()
	call search(s:regex_col(l:num).'.+$', 'wb')
endfunction


" Removes the highlighting on long lines.
function! longline#hide()
	if exists('b:longline_match')
		call deletematch(b:longline_match)
		unlet b:longline_match
	endif
endfunction


" Highlights lines beyond a certain length.
" @param {number?} Max line width. Detected from filetype if ommitted.
function! longline#show(...)
	call longline#hide()
	let l:num = a:0 > 0 ? a:1 : longline#maxlength()
	if l:num > 0
		let l:regex = s:regex_all(l:num)
		let b:longline_match = addmatch(g:longline_matchgroup, l:regex)
	endif
endfunction


" Toggles long line highlighting
" @param {number?} Max line width. Detected from filetype if ommitted.
function! longline#toggle(...)
	if exists('b:longline_match')
		call longline#hide()
	else
		call call('longline#show', a:000)
	endif
endfunction

if exists('g:longline#autoloaded') || &cp
	finish
endif
let g:longline#autoloaded = 1


" The regex for the nth column of a line.
" Args:
"   {number} num the column to search for.
" @private
function! s:Regex(num)
	return '\m\%>'.a:num.'v'
endfunction


" Highlight lines of a certain length with a certain highlight group.
" @private
function! s:LineMatch(type, num)
	exe 'match '.a:type.' "'.s:Regex(a:num).'.\+"'
endfunction


" Find the maximum allowable line length.
" Args:
"   {string?} optional filetype to check the max length of. Defaults to &ft.
" Returns:
"   The maximum allowable length of a line.
function! longline#MaxLength(...)
	let l:ft = a:0 > 0 ? a:1 : &ft
	let l:num = get(g:longline_exceptions, l:ft, -1)
	if l:num == -1
		let l:num = g:longline_maxlength
	endif
	return l:num <= 0 ? 0 : l:num
endfunction


" Determines whether or not text should be wrapped.
" Args:
"   {string?} optional filetype to check. Defaults to &ft.
" Returns:
"   1 if text should be wrapped, 0 otherwise.
function! longline#WrapText(...)
	let l:ft = a:0 > 0 ? a:1 : &ft
	let l:width = longline#MaxLength(l:ft)
	return get(g:longline_tw, l:ft, l:width > 0) <= 0 ? 0 : 1
endfunction


" Finds out whether a long line exists in the file.
" Args:
"   {number?} optional max line width. Detected from the filetype if not given.
" Returns:
"   1 if a too-long line exists, 0 otherwise.
function! longline#Exists(...)
	let l:num = a:0 > 0 ? a:1 : longline#MaxLength()
	if l:num <= 0 | return 0 | endif
	return search(s:Regex(l:num+1), 'nw') != 0
endfunction


" Jumps the cursor to the next long line.
" Args:
"   {number?} optional max line width. Detected from the filetype if not given.
function! longline#Next(...)
	let l:num = a:0 > 1 ? a:1 : longline#MaxLength()
	call search(s:Regex(l:num).'.\+$', 'w')
endfunction

" Jumps the cursor to the previous long line.
" Args:
"   {number?} optional max line width. Detected from the filetype if not given.
function! longline#Prev(...)
	let l:num = a:0 > 1 ? a:1 : longline#MaxLength()
	call search(s:Regex(l:num).'.\+$', 'wb')
endfunction


" Removes the highlighting on long lines.
function! longline#Hide()
	if exists('b:longline_highlight')
		if b:longline_highlight > 0
			call s:LineMatch('NONE', b:longline_highlight)
		endif
		unlet b:longline_highlight
	endif
endfunction


" Highlights lines beyond a certain length.
" Args:
"   {number?} optional max line width. Detected from the filetype if not given.
function! longline#Show(...)
	call longline#Hide()
	let l:num = a:0 > 0 ? a:1 : longline#MaxLength()
	if l:num > 0
		call s:LineMatch(g:longline_matchgroup, l:num)
		let b:longline_highlight = l:num
	endif
endfunction


" Toggles long line highlighting
" Args:
"   {number?} optional max line width. Detected from the filetype if not given.
function! longline#Toggle(...)
	if exists('b:longline_highlight') && b:longline_highlight > 0
		call longline#Hide()
	else
		call call('longline#Show', a:000)
	endif
endfunction

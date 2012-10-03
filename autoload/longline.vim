if exists('g:longline#autoloaded') || &cp
	finish
endif
let g:longline#autoloaded = 1


" The matchgroup to use for the parts of lines that are too long.
if !exists('g:longline#matchgroup')
	let g:longline#matchgroup = 'ErrorMsg'
endif

" How long is 'too long'.
if !exists('g:longline#maxlength')
	let g:longline#maxlength = 80
endif

" Filetypes that don't conform to the default 'too long' rule.
if !exists('g:longline#exceptions')
	let g:longline#exceptions = {
				\ 'help': 0,
				\ 'text': 0,
				\ 'html': 0,
				\ }
endif

" A dictionary of filetype => whether text should be wrapped.
" By default, if longline#MaxLength is non-zero text will be wrapped.
" Use this dictionary to override that behavior one way or the other.
" A value <= 0 indicates that text should not be wrapped.
if !exists('g:longline#tw')
	let g:longline#tw = {}
endif


" Highlight lines of a certain length with a certain highlight group.
" @private
function! s:LineMatch(type, num)
	exe 'match '.a:type.' "\m\%>'.a:num.'v.\+"'
endfunction



" Add an exception for a filetype.
" Args:
"   {string} filetype the filetype to add an exception for
"   {number?} optional max width. If 0 then lines of any length are allowed.
function! longline#AddException(filetype, ...)
	let g:longline#exceptions[a:filetype] = a:0 > 0 ? a:1 : 0
endfunction

" Remove an exception.
" Args:
"   {string} filetype to remove the exception for.
function! longline#RemoveException(filetype)
	try | call remove(g:longline#exceptions, a:filetype) | endtry
endfunction!

" Never wrap text on a given filetype.
" Args:
"   {string} filetype the filetype to never wrap text on.
function! longline#NeverWrap(filetype)
	let g:longline#tw[a:filetype] = 0
endfunction


" Find the maximum allowable line length.
" Args:
"   {string?} optional filetype to check the max length of. Defaults to &ft.
" Returns:
"   The maximum allowable length of a line.
function! longline#MaxLength(...)
	let l:ft = a:0 > 0 ? a:1 : &ft
	let l:num = get(g:longline#exceptions, l:ft, -1)
	if l:num == -1
		let l:num = g:longline#maxlength
	endif
	return l:num <= 0 ? 0 : l:num
endfunction


" Whether or not text should be wrapped.
" Args:
"   {string?} optional filetype to check. Defaults to &ft.
" Returns:
"   1 if text should be wrapped, 0 otherwise.
function! longline#WrapText(...)
	let l:ft = a:0 > 0 ? a:1 : &ft
	let l:width = longline#MaxLength(l:ft)
	return get(g:longline#tw, l:ft, l:width > 0) <= 0 ? 0 : 1
endfunction


" Finds out whether a long line exists in the file.
" Args:
"   {number?} optional max line width. Deteced from the filetype if not given.
" Returns:
"   1 if a too-long line exists, 0 otherwise.
function! longline#Exists(...)
	let l:num = a:0 > 0 ? a:1 : longline#MaxLength()
	if l:num <= 0 | return 0 | endif
	return search('\m\%>'.l:num.'v.', 'nw') != 0
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
"   {number?} optional max line width. Deteced from the filetype if not given.
function! longline#Show(...)
	call longline#Hide()
	let l:num = a:0 > 0 ? a:1 : longline#MaxLength()
	if l:num > 0
		call s:LineMatch(g:longline#matchgroup, l:num)
		let b:longline_highlight = l:num
	endif
endfunction

" Toggles long line highlighting
" Args:
"   {number?} optional max line width. Deteced from the filetype if not given.
function! longline#Toggle(...)
	if exists('b:longline_highlight') && b:longline_highlight > 0
		call longline#Hide()
	else
		call call('longline#Show', a:000)
	endif
endfunction

function! longline#status#flag()
	return longline#status#warning()
endfunction


function! longline#status#warning()
	return longline#exists() ? '[…]' : ''
endfunction

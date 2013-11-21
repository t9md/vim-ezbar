let f = {} | let s:f = f
function! f.mode() "{{{1
endfunction
function! f.percent() "{{{1
endfunction
function! f.encoding() "{{{1
endfunction
function! f.fileformat() "{{{1
endfunction

function! easy_statusline#functions#default()
  return s:f
endfunction
" vim: foldmethod=marker


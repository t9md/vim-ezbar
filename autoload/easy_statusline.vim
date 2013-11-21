let es = {} | let s:es = {}

let g:easy_statusline = {}
let g:easy_statusline.layout = [
      \ 'mode',
      \ 'filetype',
      \ '__SEP__',
      \ 'percent',
      \ ]

function! es.string() "{{{1
  let r = []
  let default_f = easy_statusline#function#default()
  for part in g:easy_statusline.layout
    let r += default_f.part
  endfor
  let s = join(r, ' ')
  return s
endfunction

function! easy_statusline#string() "{{{1
  return s:es.string()
endfunction
function! easy_statusline#set() "{{{1
  let &statusline='%!easy_statusline#string()'
endfunction
" vim: foldmethod=marker

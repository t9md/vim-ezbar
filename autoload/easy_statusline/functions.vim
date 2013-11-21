let f = {} | let s:f = f
let s:mode_map = {
      \ 'n' : { 's': 'N', 'c': 'SmallsCurrent' },
      \ 'i' : { 's': 'I', 'c': 'Type' },
      \ 'R' : 'R ',
      \ 'v' : 'V ',
      \ 'V' : 'VL',
      \ "\<C-v>": 'VB',
      \ 'c' : 'C ',
      \ 's' : 'S ',
      \ 'S' : 'SL',
      \ "\<C-s>": 'SB',
      \ '?': '  ' }
function! f.mode() "{{{1
  return s:mode_map[mode()]
endfunction
function! f.percent() "{{{1
  return '%p%%'
endfunction
function! f.line() "{{{1
  return '%l/%L'
endfunction
function! f.encoding() "{{{1
endfunction
function! f.fileformat() "{{{1
endfunction
function! f.filetype() "{{{1
  return &ft
endfunction


let default = easy_statusline#functions#default()
let u = {} | let s:u = u
function! u.textmanip() "{{{1
  let s = toupper(g:textmanip_current_mode[0])
  return { 's' : s, 'c': s == 'R' ? 'Statement' : 'Function' }
endfunction

function! easy_statusline#functions#default()
  return extend(deepcopy(s:f), s:u, 'error')
endfunction
" vim: foldmethod=marker


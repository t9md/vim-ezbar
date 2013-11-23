let f = {} | let s:f = f
let s:mode_map = {
      \ 'n':      { 's': 'N ', 'c': ['SkyBlue3', 'Black'] },
      \ 'i':      { 's': 'I ', 'c': ['PaleGreen3', 'Black'] },
      \ 'R':      { 's': 'R ', 'c': [ 'tomato1', 'Black' ] },
      \ 'v':      { 's': 'V ', 'c': [ 'PaleVioletRed', 'Black'] },
      \ 'V':      { 's': 'VL', 'c': [ 'PaleVioletRed', 'Black'] }, 
      \ "\<C-v>": { 's': 'VB', 'c': [ 'PaleVioletRed', 'Black'] }, 
      \ 'c':      { 's': 'C ', 'c': 'Type' },
      \ 's':      { 's': 'S ', 'c': 'Type' },
      \ 'S':      { 's': 'SL', 'c': 'Type' },
      \ "\<C-s>": { 's': 'SB', 'c': 'Type' },
      \ '?':      { 's': '  ', 'c': 'Type' },
      \ }

function! f.mode() "{{{1
  return s:mode_map[mode()]
endfunction
function! f.percent() "{{{1
  let s  = '%3p%%'
  return { 's': s, 'ac' : ['gray40', 'gray95'] }
endfunction
" function! f.percent() "{{{1
  " let s  = '%3p%%'
  " if self.__is_active 
    " return { 's': s, 'c' : ['gray40', 'gray95'] }
  " else
     " return s
  " endif
" endfunction
function! f.modified() "{{{1
  return &modified ? '+' : ''
endfunction
function! f.readonly() "{{{1
  return &readonly ? 'RO' : ''
endfunction
function! f.line_col() "{{{1
  " return { 's': '%3l:%-2c', 'ac' : ['gray58', 'Red'], 'ic'
  return { 's': '%3l:%-2c', 'ac' : ['gray58', 'Black'] }
endfunction
function! f.line() "{{{1
  return '%l/%L'
endfunction
function! f.encoding() "{{{1
  return &enc
endfunction
function! f.fileformat() "{{{1
  return &fileformat
endfunction
function! f.filetype() "{{{1
  return &ft
endfunction "}}}
function! f.filename() "{{{1
  return '%t'
endfunction "}}}
function! f.__SEP__() "{{{1
  let ac = get(g:ezbar.active,   'sep_color', g:ezbar.active.default_color)
  let ic = get(g:ezbar.inactive, 'sep_color', g:ezbar.inactive.default_color)
  return { 's': '%=', 'ac': ac, 'ic': ic,  }
endfunction "}}}

" Public:
function! ezbar#parts#default#new()
  return deepcopy(s:f)
endfunction

function! ezbar#parts#default#use(list) "{{{1
  let p = {}
  for part in a:list
    let p[part] = s:f[part]
  endfor
  return deepcopy(p)
endfunction

function! ezbar#parts#default#list()
  return keys(s:f)
endfunction
" vim: foldmethod=marker


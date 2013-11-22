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

function! f._mode() "{{{1
  return s:mode_map[mode()]
endfunction
function! f._percent() "{{{1
  return { 's': '%3p%%', 'c' : ['gray40', 'gray95'] }
endfunction
function! f._modified() "{{{1
  return &modified ? '+' : ''
endfunction
function! f._readonly() "{{{1
  return &readonly ? 'RO' : ''
endfunction
function! f._line_col() "{{{1
  return { 's': '%3l:%-2c ', 'c' : ['gray58', 'Black'] }
endfunction
function! f._line() "{{{1
  return '%l/%L'
endfunction
function! f._encoding() "{{{1
  return &enc
endfunction
function! f._fileformat() "{{{1
  return &fileformat
endfunction
function! f._filetype() "{{{1
  return &ft
endfunction "}}}
function! f._filename() "{{{1
  return '%t'
endfunction "}}}

" Public:
function! ezbar#functions#default()
  return deepcopy(s:f)
endfunction
function! ezbar#functions#default_names()
  return keys(s:f)
endfunction
" vim: foldmethod=marker


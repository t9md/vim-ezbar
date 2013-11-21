let f = {} | let s:f = f
let s:mode_map = {
      \ 'n':      { 's': 'N', 'c': 'Type' },
      \ 'i':      { 's': 'I', 'c':  'SmallsCurrent' },
      \ 'R':      { 's': 'R ', 'c': 'Type' },
      \ 'v':      { 's': 'V ', 'c': 'Statement' },
      \ 'V':      { 's': 'VL', 'c': 'Statement' },
      \ "\<C-v>": { 's': 'VB', 'c': 'Statement' },
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
  return '%3p%%'
endfunction
function! f._modified() "{{{1
  return &modified ? '+' : ''
endfunction
function! f._readonly() "{{{1
  return &readonly ? 'RO' : ''
endfunction
function! f._line_col() "{{{1
  return { 's': '%3l:%-2c ', 'c' : 'EasyStatusLine27' }
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

" Public:
function! easy_statusline#functions#default()
  return deepcopy(s:f)
endfunction
function! easy_statusline#functions#default_names()
  return keys(s:f)
endfunction
" vim: foldmethod=marker


" This is merely sample configration to show concept.
" If you want to improve or don't like this.
" Use your own parts based on this sample.
let s:f = {}
let s:mode_map = {
      \ 'n':      { 's': 'N ', 'c': { 'gui': ['SkyBlue3',      'Black'] }},
      \ 'i':      { 's': 'I ', 'c': { 'gui': ['PaleGreen3',    'Black'] }},
      \ 'R':      { 's': 'R ', 'c': { 'gui': ['tomato1',       'Black'] }},
      \ 'v':      { 's': 'V ', 'c': { 'gui': ['PaleVioletRed', 'Black'] }},
      \ 'V':      { 's': 'VL', 'c': { 'gui': ['PaleVioletRed', 'Black'] }},
      \ "\<C-v>": { 's': 'VB', 'c': { 'gui': ['PaleVioletRed', 'Black'] }},
      \ 'c':      { 's': 'C ', 'c': 'Type' },
      \ 's':      { 's': 'S ', 'c': 'Type' },
      \ 'S':      { 's': 'SL', 'c': 'Type' },
      \ "\<C-s>": { 's': 'SB', 'c': 'Type' },
      \ '?':      { 's': '  ', 'c': 'Type' },
      \ }

function! s:f.mode() "{{{1
  let mode = mode()
  return get(s:mode_map, mode, mode)
endfunction

function! s:f.percent() "{{{1
  let s  = '%3p%%'
  return { 's': s, 'ac' : { 'gui': ['gray40', 'gray95'] }}
endfunction

function! s:f.modified() "{{{1
  return &modified ? '+' : ''
endfunction

function! s:f.readonly() "{{{1
  return &readonly ? 'RO' : ''
endfunction

function! s:f.line_col() "{{{1
  return { 's': '%3l:%-2c', 'ac' : { 'gui': ['gray58', 'Black'] }}
endfunction

function! s:f.line() "{{{1
  return '%l/%L'
endfunction

function! s:f.encoding() "{{{1
  return &enc
endfunction

function! s:f.fileformat() "{{{1
  return &fileformat
endfunction

function! s:f.filetype() "{{{1
  return &ft
endfunction "}}}

function! s:f.filename() "{{{1
  return '%t'
endfunction "}}}

" Public:
function! ezbar#parts#default#new()
  return deepcopy(s:f)
endfunction

function! ezbar#parts#default#list()
  return keys(s:f)
endfunction
" vim: foldmethod=marker


" This is merely sample configration to show concept.
" If you want to improve or don't like this.
" Use your own parts based on this sample.
let s:f = {}
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

function! s:f.mode() "{{{1
  let mode = mode()
  return get(s:mode_map, mode, mode)
endfunction
function! s:f.percent() "{{{1
  let s  = '%3p%%'
  return { 's': s, 'ac' : ['gray40', 'gray95'] }
endfunction
function! s:f.modified() "{{{1
  return &modified ? '+' : ''
endfunction
function! s:f.readonly() "{{{1
  return &readonly ? 'RO' : ''
endfunction
function! s:f.line_col() "{{{1
  " return { 's': '%3l:%-2c', 'ac' : ['gray58', 'Red'], 'ic'
  return { 's': '%3l:%-2c', 'ac' : ['gray58', 'Black'] }
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
" function! s:f.__SEP__() "{{{1
  " let ac = get(g:ezbar.active,   'sep_color', "Normal")
  " let ic = get(g:ezbar.inactive, 'sep_color', "Normal")
  " return { 's': '%=', 'ac': ac, 'ic': ic,  }
" endfunction "}}}

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


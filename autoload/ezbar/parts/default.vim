function! s:plog(msg) "{{{1
  cal vimproc#system('echo "' . PP(a:msg) . '" >> ~/vim.log')
endfunction "}}}
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

function! s:f.mode(_) "{{{1
  let mode = mode()
  return get(s:mode_map, mode, mode)
endfunction

function! s:f.percent(_) "{{{1
  let s  = ' %3p%% '
  return { 's': s, 'ac' : { 'gui': ['gray40', 'gray95'] }}
endfunction

function! s:f.modified(_) "{{{1
  return getwinvar(a:_, '&modified') ? '+' : ''
endfunction

function! s:f.readonly(_) "{{{1
  return getwinvar(a:_, '&readonly') ? 'RO' : ''
endfunction

function! s:f.line_col(_) "{{{1
  return { 's': '%3l:%-2c', 'ac' : { 'gui': ['gray58', 'Black'] }}
endfunction

function! s:f.line(_) "{{{1
  return ' %l/%L '
endfunction

function! s:f.encoding(_) "{{{1
  return getwinvar(a:_, '&encoding')
endfunction

function! s:f.fileformat(_) "{{{1
  return getwinvar(a:_, '&fileformat')
endfunction

function! s:f.filetype(_) "{{{1
  return getwinvar(a:_, '&filetype')
endfunction "}}}

function! s:f.filename(_) "{{{1
  return fnamemodify(bufname(winbufnr(a:_)), ':t')
endfunction "}}}

" Public:
function! ezbar#parts#default#new()
  return deepcopy(s:f)
endfunction

function! ezbar#parts#default#list()
  return keys(s:f)
endfunction
" vim: foldmethod=marker


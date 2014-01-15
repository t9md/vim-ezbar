" This is merely sample configration to show concept.
" If you want to improve or don't like this.
" Use your own parts based on this sample.

" map <SID>xx <SID>xx
" let s:sid = maparg("<SID>xx")
" unmap <SID>xx
" let s:SID = substitute(s:sid, 'xx', '', '')

let s:u = {}
let s:mode_map = {
      \ 'n':      { 's': 'N ', 'c': { 'gui': ['SkyBlue3',      'Black'], 'cterm': [33, 16] }},
      \ 'i':      { 's': 'I ', 'c': { 'gui': ['PaleGreen3',    'Black'], 'cterm': [10, 16] }},
      \ 'R':      { 's': 'R ', 'c': { 'gui': ['tomato1',       'Black'], 'cterm': [ 1, 16] }},
      \ 'v':      { 's': 'V ', 'c': { 'gui': ['PaleVioletRed', 'Black'], 'cterm': [ 9, 16] }},
      \ 'V':      { 's': 'VL', 'c': { 'gui': ['PaleVioletRed', 'Black'], 'cterm': [ 9, 16] }},
      \ "\<C-v>": { 's': 'VB', 'c': { 'gui': ['PaleVioletRed', 'Black'], 'cterm': [ 9, 16] }},
      \ 'c':      { 's': 'C ', 'c': 'Type' },
      \ 's':      { 's': 'S ', 'c': 'Type' },
      \ 'S':      { 's': 'SL', 'c': 'Type' },
      \ "\<C-s>": { 's': 'SB', 'c': 'Type' },
      \ '?':      { 's': '  ', 'c': 'Type' },
      \ }

function! s:u.mode(_) "{{{1
  let mode = mode()
  return get(s:mode_map, mode, mode)
endfunction

function! s:u.percent(_) "{{{1
  return '%p%%'
endfunction

function! s:u.modified(_) "{{{1
  return getwinvar(a:_, '&modified') ? '+' : ''
endfunction

function! s:u.readonly(_) "{{{1
  return getwinvar(a:_, '&readonly') ? 'RO' : ''
endfunction

function! s:u.line_col(_) "{{{1
  return '%3l:%-2c'
endfunction

function! s:u.line(_) "{{{1
  return '%l/%L'
endfunction

function! s:u.encoding(_) "{{{1
  return getwinvar(a:_, '&encoding')
endfunction

function! s:u.fileformat(_) "{{{1
  return getwinvar(a:_, '&fileformat')
endfunction

function! s:u.filetype(_) "{{{1
  return getwinvar(a:_, '&filetype')
endfunction

function! s:u.filename(_) "{{{1
  return fnamemodify(bufname(winbufnr(a:_)), ':t')
endfunction

function! s:u.winnr(_) "{{{1
  return a:_
endfunction
"}}}

" Public:
function! ezbar#parts#default#new() "{{{1
  return deepcopy(s:u)
endfunction

function! ezbar#parts#default#use(list) "{{{1
  if !exists('s:all')
    let s:all = ezbar#parts#default#new()
  endif
  let R = {}
  for part in a:list
    let R[part] = s:all[part]
  endfor
  return R
endfunction

function! ezbar#parts#default#list()
  return keys(s:u)
endfunction

" vim: foldmethod=marker

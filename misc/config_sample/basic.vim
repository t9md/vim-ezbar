let s:colors = {
      \ '1': {'gui': [ 'gray3', 'coral1'] },
      \ '2': {'gui': [ 'gray51', 'black'] },
      \ '3': {'gui': [ 'gray21', 'white'] },
      \ '4': 'StatusLineNC',
      \ }

let g:ezbar             = {}
let g:ezbar.colors      = s:colors
let g:ezbar.separator_L = '|'
let g:ezbar.separator_R = '|'
unlet s:colors

 " Layout: {{{
let g:ezbar.active = [
      \ 'mode',
      \ '---mode',
      \ 'winnr',
      \ 'bufnr',
      \ '---1',
      \ 'cwd',
      \ '===',
      \ '---2',
      \ 'readonly',
      \ 'filename',
      \ 'modified',
      \ 'filetype',
      \ 'encoding',
      \ '---mode',
      \ 'percent',
      \ 'line_col',
      \ ]
let g:ezbar.inactive = [
      \ 'winnr',
      \ 'bufnr',
      \ 'modified',
      \ '===4',
      \ 'filetype',
      \ 'filename',
      \ 'encoding',
      \ ]
 " }}}

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
  let R = get(s:mode_map, mode, mode)
  let g:ezbar.colors['mode'] = R.c
  return R
endfunction

function! s:u.winnr(_) "{{{1
  return printf('w:%d', a:_)
endfunction


function! s:u.bufnr(_) "{{{1
  return printf('b:%d', winbufnr(a:_))
endfunction


function! s:u.cwd(_) "{{{1
  let cwd = substitute(getcwd(), expand($HOME), '~', '')
  return cwd
endfunction

function! s:u._parts_missing(_, part) "{{{1
  let color = matchstr(a:part, '\v^[-=]{3}\zs.*')
  if !empty(color)
    let self.__default_color = g:ezbar.colors[color]
  endif

  if a:part =~# '^=\+'
    return {'s': '%=' }
  endif
endfunction
"}}}

let g:ezbar.parts = extend(ezbar#parts#default#new(), s:u)
" vim: foldmethod=marker

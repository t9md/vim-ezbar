" ModeMap:
" {{{
let s:mode_map_default = {
      \ 'n':      [ 'NORMAL ', 'N ' ],
      \ 'i':      [ 'INSERT ', 'I ' ],
      \ 'R':      [ 'REPLACE', 'R ' ],
      \ 'v':      [ 'VISUAL ', 'V ' ],
      \ 'V':      [ 'V-LINE ', 'VL' ],
      \ "\<C-v>": [ 'V-BLOCK', 'VB' ],
      \ 'c':      [ 'COMMAND', 'C ' ],
      \ 's':      [ 'SELECT ', 'S ' ],
      \ 'S':      [ 'S-LINE ', 'SL' ],
      \ "\<C-s>": [ 'S-BLOCK', 'SB' ],
      \ '?':      [ '       ', '  ' ],
      \ }
"}}}

" Main:
let s:u = {}
function! s:u.mode(_) "{{{1
  let mode = self.__mode
  let [ long, short ] = has_key(g:ezbar, 'mode_map')
        \ ? get(g:ezbar.mode_map,   mode)
        \ : get(s:mode_map_default, mode)
  let s = self.__width > 80 ? long : short
  return s
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
  return '%l:%c'
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

function! s:u.win_buf(_) "{{{1
  return printf('w:%d b:%d', a:_, winbufnr(a:_))
endfunction
"}}}
function! ezbar#parts#default#new() "{{{1
  return deepcopy(s:u)
endfunction
"}}}

" vim: foldmethod=marker

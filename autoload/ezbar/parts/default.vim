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
function! s:u.mode() "{{{1
  let mode = self.__mode
  let [ long, short ] = has_key(g:ezbar, 'mode_map')
        \ ? get(g:ezbar.mode_map,   mode)
        \ : get(s:mode_map_default, mode)
  let s = self.__width > 90 ? long : short
  return s
endfunction

function! s:u.percent() "{{{1
  return '%p%%'
endfunction

function! s:u.modified() "{{{1
  return getwinvar(self.__winnr, '&modified') ? '+' : ''
endfunction

function! s:u.readonly() "{{{1
  return getwinvar(self.__winnr, '&readonly') ? 'RO' : ''
endfunction

function! s:u.line_col() "{{{1
  return '%l:%c'
endfunction

function! s:u.line() "{{{1
  return '%l/%L'
endfunction

function! s:u.encoding() "{{{1
  return getwinvar(self.__winnr, '&encoding')
endfunction

function! s:u.fileformat() "{{{1
  return getwinvar(self.__winnr, '&fileformat')
endfunction

function! s:u.filetype() "{{{1
  return self.__filetype
endfunction

function! s:u.filename() "{{{1
  return fnamemodify(bufname(self.__bufnr), ':t')
endfunction

function! s:u.winnr() "{{{1
  return self.__winnr
endfunction

function! s:u.win_buf() "{{{1
  return printf('w:%d b:%d', self.__winnr, self.__bufnr)
endfunction
"}}}
function! ezbar#parts#default#new() "{{{1
  return deepcopy(s:u)
endfunction
"}}}

" vim: foldmethod=marker

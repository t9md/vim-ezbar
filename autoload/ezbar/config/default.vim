let g:ezbar       = {}
let g:ezbar.theme = 'default'
" let g:ezbar.color = {}

 " Layout:
 " {{{
let g:ezbar.active = [
      \ '----------- 1',
      \ 'mode',
      \ '----------- 2',
      \ 'win_buf',
      \ '----------- 3',
      \ 'cwd',
      \ '===========',
      \ 'readonly',
      \ '----------- 2',
      \ 'filename',
      \ 'filetype',
      \ '----------- 1',
      \ 'modified',
      \ 'encoding',
      \ 'percent',
      \ 'line_col',
      \ ]
let g:ezbar.inactive = [
      \ '----------- inactive',
      \ 'win_buf',
      \ 'modified',
      \ '==========',
      \ 'filename',
      \ 'filetype',
      \ 'encoding',
      \ 'line_col',
      \ ]
 " }}}

let s:features = [
      \ 'mode',
      \ 'readonly',
      \ 'filename',
      \ 'modified',
      \ 'filetype',
      \ 'win_buf',
      \ 'encoding',
      \ 'percent',
      \ 'line_col'
      \ ]
let s:u = ezbar#parts#use('default', {'parts': s:features })
unlet s:features

function! s:u.cwd(_) "{{{1
  let cwd = substitute(getcwd(), expand($HOME), '~', '')
  let display =
        \ self.__width < 90 ? -15 :
        \ self.__width < 45 ? -10 : 0
  return cwd[ display :  -1 ]
endfunction

function! s:u._init(_) "{{{1
  let hide = []
  if self.__width < 70
    let hide += ['encoding', 'percent', 'filetype']
  endif
  call filter(self.__layout, 'index(hide, v:val) ==# -1')
endfunction
"}}}

let g:ezbar.parts = s:u
unlet s:u
" vim: foldmethod=marker

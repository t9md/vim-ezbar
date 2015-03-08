" Parts:
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

let s:parts = ezbar#parts#use('default', {'parts': s:features })
unlet s:features

function! s:parts.cwd() "{{{1
  let cwd = substitute(getcwd(), expand($HOME), '~', '')
  let display =
        \ self.__width < 90 ? -15 :
        \ self.__width < 45 ? -10 : 0
  return cwd[ display :  -1 ]
endfunction

function! s:parts.__init() "{{{1
  let hide = []
  if self.__width < 70
    let hide += ['encoding', 'percent', 'filetype']
  endif
  call filter(self.__layout, 'index(hide, v:val) ==# -1')
endfunction

" Main:
let s:config = {}
let s:config.theme = 'default'
let s:config.parts = s:parts
unlet s:parts

let s:config.active = [
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
let s:config.inactive = [
      \ '----------- inactive',
      \ 'win_buf',
      \ 'modified',
      \ '==========',
      \ 'filename',
      \ 'filetype',
      \ 'encoding',
      \ 'line_col',
      \ ]

function! ezbar#config#default#get() abort
  return s:config
endfunction
" vim: foldmethod=marker

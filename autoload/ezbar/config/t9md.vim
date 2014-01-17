" Surely not work as-is in your environment.
" Since this is my specific configuration

" The purpose for this file put here is show you 
" how you can
"
" - customize color within parts
" - how to use hook
"

let g:ezbar       = {}
let g:ezbar.theme = 'default'
let g:ezbar.color = {
      \ '_warn': { 'gui': 'red', 'cterm': 9     },
      \ '_info': { 'gui': 'yellow', 'cterm': 35 },
      \ '_pink': { 'gui': 'DeepPink', 'cterm': '15' },
      \ }

 " Layout:
 " {{{
let g:ezbar.active = [
      \ '----------- mood1',
      \ 'mode',
      \ '----------- mood2',
      \ 'readonly',
      \ 'win_buf',
      \ 'fugitive',
      \ '----------- mood3',
      \ 'textmanip',
      \ 'cwd',
      \ '===========',
      \ '----------- mood2',
      \ 'filename',
      \ 'modified',
      \ 'filetype',
      \ '----------- mood1',
      \ 'encoding',
      \ 'percent',
      \ 'line_col',
      \ 'choosewin',
      \ 'validate',
      \ ]
      " \ 'watch_var',
      " \ 'letval',
let g:ezbar.inactive = [
      \ '----------- inactive',
      \ 'win_buf',
      \ 'modified',
      \ '==========',
      \ 'filename',
      \ 'filetype',
      \ 'encoding',
      \ 'choosewin',
      \ ]
 " }}}

let s:features = ['mode', 'readonly',
      \ 'filename', 'modified', 'filetype', 'win_buf',
      \ 'encoding', 'percent', 'line_col'
      \ ]

let s:u = ezbar#parts#default#use(s:features)
unlet s:features

function! s:u.cfi(_) "{{{1
  if exists('*cfi#format')
    return { 's': cfi#format('%.43s()', '') }
  end
  return ''
endfunction

function! s:u.watch_var(_) "{{{1
  if g:watch_var is ''
    return ''
  endif
  try
    return string(g:watch_var)
  catch
    return ''
  endtry
endfunction

function! s:u.choosewin(_) "{{{1
  return g:choosewin_label[a:_ - 1]
endfunction

function! s:u.validate(_) "{{{1
  for F in [ self.trailingWS, self.mixed_indent ]
    let R = call(F, [a:_] , self)
    if !empty(R)
      return { 's': R, 'c': self.__color.warn }
    endif
    unlet R
  endfor
  return ''
endfunction

function! s:u.trailingWS(_) "{{{1
  if !empty(self.__buftype)
    return ''
  endif
  if index(s:trailingWS_exclude_filetype, self.__filetype) !=# -1
    return ''
  endif
  let line = search(' $', 'nw')
  if !empty(line)
    return 'trail: ' . line
  endif
endfunction
let s:trailingWS_exclude_filetype = ['unite', 'markdown']

function! s:u.mixed_indent(_) "{{{1
  if getwinvar(a:_, '&ft') == 'help'
    return
  endif
  let indents = [
        \ search('^ \{2,}', 'nb'),
        \ search('^ \{2,}', 'n'),
        \ search('^\t', 'nb'),
        \ search('^\t', 'n')
        \ ]
  let mixed = indents[0] != 0 && indents[1] != 0 && indents[2] != 0 && indents[3] != 0
  if mixed
    let mixnr = indents[0] == indents[1] ? indents[0] : indents[2]
    return 'indent: ' . mixnr
  endif
endfunction


function! s:u.textmanip(_) "{{{1
  if !exists('g:textmanip_current_mode') | return '' | endif
  return g:textmanip_current_mode[0] is 'r'
        \ ? { 's' : '[R]', 'c': self.__.fg(self.__color._pink) }
        \ : ''
endfunction

function! s:u.cwd(_) "{{{1
  let cwd = substitute(getcwd(), expand($HOME), '~', '')
  let cwd = substitute(cwd, '\V~/.vim/bundle/', '[bdl]', '')
  let display =
        \ self.__width < 90 ? -15 :
        \ self.__width < 45 ? -10 : 0
  return cwd[ display :  -1 ]
endfunction

function! s:u.smalls(_) "{{{1
  if !exists('g:smalls_current_mode') | return '' | endif
  let s = g:smalls_current_mode
  if empty(s) | return '' | endif
  return { 's': s,
        \ 'c': ( s is 'exc') ? 'SmallsCurrent' : ' SmallsCandidate' }
endfunction

function! s:u.fugitive(_) "{{{1
  let s = fugitive#head()
  if s ==# 'master' | return s | endif
  return { 's': s, 'c': self.__.fg(self.__color._warn) }
endfunction

function! s:u._init(_) "{{{1
  let hide = []
  if get(g:, 'choosewin_active', 0)
    let hide += [ 'validate' ]
  endif
  if self.__width < 90
    " let hide += ['cwd']
  endif
  if self.__width < 70
    let hide += ['encoding', 'percent', 'filetype']
  endif
  if self.__width < 60
    let hide += ['fugitive']
  endif
  call filter(self.__layout, 'index(hide, v:val) ==# -1')
endfunction


function! s:u._finish(_) "{{{1
  let PARTS = self.__parts
  " if has_key(self.__parts, 'smalls')
    " let self.__layout = [self.__parts.smalls]
  " endif
  if self.__.s('filename') =~# 'tryit\.\|default\.vim'
    let PARTS.filename.c = self.__.fg(PARTS.filename.c, self.__color._info)
  endif
endfunction

function! s:u._parts_missing(_, part) "{{{1
endfunction
"}}}

let g:ezbar.parts = s:u
unlet s:u
" vim: foldmethod=marker

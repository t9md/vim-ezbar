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
let g:ezbar.hide_rule = {
      \ 90: ['cwd'],
      \ 65: ['fugitive'],
      \ 60: ['encoding', 'filetype'],
      \ 50: ['percent']
      \ }

 " Layout:
 " {{{
let g:ezbar.active = [
      \ '----------- 1',
      \ 'mode',
      \ '----------- 2',
      \ 'smalls',
      \ 'readonly',
      \ 'win_buf',
      \ 'fugitive',
      \ '----------- 3',
      \ 'textmanip',
      \ 'cwd',
      \ '===========',
      \ '----------- 2',
      \ 'filename',
      \ 'modified',
      \ 'filetype',
      \ '----------- 1',
      \ 'encoding',
      \ 'percent',
      \ 'line_col',
      \ 'winwidth',
      \ 'validate',
      \ ]
let g:ezbar.inactive = [
      \ '----------- inactive',
      \ 'win_buf',
      \ 'modified',
      \ '==========',
      \ 'filename',
      \ 'filetype',
      \ 'encoding',
      \ ]
 " }}}

let s:features = ['mode', 'readonly',
      \ 'filename', 'modified', 'filetype', 'win_buf',
      \ 'encoding', 'percent', 'line_col'
      \ ]
let s:u = ezbar#parts#use('default', {'parts': s:features })
unlet s:features

function! s:u.cfi(_) "{{{1
  if exists('*cfi#format')
    return { 's': cfi#format('%.43s()', '') }
  end
  return ''
endfunction

function! s:u.winwidth(_) "{{{1
  return self.__width
endfunction

function! s:u.watch_var(_) "{{{1
  try
    return (g:watch_var isnot '') ? string(g:watch_var) : ''
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
  if self.__buftype isnot# '' || self.__mode isnot# 'n'
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
        \ 'c': ( s is 'exc') ? 'SmallsCurrent' : 'SmallsCandidate' }
endfunction

function! s:u.fugitive(_) "{{{1
  let s = fugitive#head()
  if s ==# 'master' | return s | endif
  return { 's': s, 'c': self.__.fg(self.__color._warn) }
endfunction

function! s:u._init(_) "{{{1
  if !self.__active
    return
  endif

  if self.__width < 60
    let self.__layout = self.__layout[2:] + self.__layout[1:1]
  endif
  if exists('g:smalls_current_mode') && !empty(g:smalls_current_mode)
    let self.__layout = [ 'smalls' ]
    return
  endif

  let self.hide_list = []
  if get(g:, 'choosewin_active', 0)
    let self.hide_list += [ 'validate' ]
  endif
  call self.hide()
endfunction

function! s:u.hide() "{{{1
  for [ limit, parts ] in items(g:ezbar.hide_rule)
    if self.__width < limit
      let self.hide_list += parts
    endif
  endfor
  call filter(self.__layout, 'index(self.hide_list, v:val) ==# -1')
endfunction

function! s:u._finish(_) "{{{1
  let PARTS = self.__parts
  if self.__.s('filename') =~# 'tryit\.\|default\.vim'
    let PARTS['filename'].c = self.__.fg(PARTS['filename'].c, self.__color._info)
  endif
endfunction

function! s:u._parts_missing(_, part) "{{{1
endfunction
"}}}

let g:ezbar.parts = s:u
unlet s:u
" vim: foldmethod=marker

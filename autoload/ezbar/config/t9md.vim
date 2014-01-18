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

let g:ezbar.separator_L        = '»'
let g:ezbar.separator_R        = '«'
let g:ezbar.separator_border_L = ''
let g:ezbar.separator_border_R = ''

" let g:ezbar.separator_L        = '»'
" let g:ezbar.separator_R        = '«'
" let g:ezbar.separator_border_L = '»'
" let g:ezbar.separator_border_R = '«'

let g:ezbar.hide_rule = {
      \ 90: ['cwd'],
      \ 65: ['fugitive'],
      \ 60: ['encoding', 'filetype'],
      \ 50: ['percent'],
      \ 35: ['mode', 'readonly', 'cwd'],
      \ }

 " Layout:
let g:ezbar.active = [
      \ '----------- 1',
      \ 'mode',
      \ '----------- 2',
      \ 'fugitive',
      \ 'win_buf',
      \ 'smalls',
      \ 'readonly',
      \ '----------- 3',
      \ 'textmanip',
      \ 'cwd',
      \ '=========== ',
      \ '----------- 2',
      \ '_filename',
      \ 'modified',
      \ 'filetype',
      \ '----------- 1',
      \ 'encoding',
      \ 'percent',
      \ 'line_col',
      \ 'winwidth',
      \ 'validate',
      \ ]
      " \ 'watch_var',
let g:ezbar.inactive = [
      \ '----------- inactive',
      \ 'win_buf',
      \ 'modified',
      \ '==========',
      \ 'filename',
      \ 'filetype',
      \ 'encoding',
      \ ]
      " \ 'watch_var',

let s:features = ['mode', 'readonly',
      \ 'filename', 'modified', 'filetype', 'win_buf',
      \ 'encoding', 'percent', 'line_col'
      \ ]

let s:u = ezbar#parts#use('default', {'parts': s:features })
unlet s:features

function! s:u.cfi() "{{{1
  if exists('*cfi#format')
    return { 's': cfi#format('%.43s()', '') }
  end
  return ''
endfunction

function! s:u._filename()
  let s = self.filename()
  let notify_sym = '★'
  if s =~# 'tryit\.\|default\.vim\|phrase__'
    return {
          \ 's' : notify_sym . s,
          \ 'c'  : self.__.fg(self.__color._info) }
  else
    return s
  endif
endfunction

function! s:u.winwidth() "{{{1
  return self.__width
endfunction

function! s:u.watch_var() "{{{1
  try
    return string(get(w:, 'zoom', ''))
  catch
    return ''
  endtry
endfunction

function! s:u.choosewin() "{{{1
  return g:choosewin_label[self.__winnr - 1]
endfunction

function! s:u.validate() "{{{1
  for funcname in [ 'trailingWS', 'mixed_indent' ]
    let R = self[funcname]()
    if !empty(R)
      return { 's': R, 'c': self.__color.warn }
    endif
    unlet R
  endfor
  return ''
endfunction

function! s:u.trailingWS() "{{{1
  if self.__buftype isnot# '' || self.__mode isnot# 'n'
    return ''
  endif
  if index(s:trailingWS_exclude_filetype, self.__filetype) !=# -1
    return ''
  endif
  let line = search(' $', 'nw')
  if !empty(line)
    let trail_symbol = 'Ξ'
    return trail_symbol . line
  endif
endfunction
let s:trailingWS_exclude_filetype = ['unite', 'markdown']

function! s:u.mixed_indent() "{{{1
  if self.__filetype == 'help'
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
    let indent_symbol = '> '
    return indent_symbol . mixnr
  endif
endfunction

function! s:u.textmanip() "{{{1
  if !exists('g:textmanip_current_mode') | return '' | endif
  return g:textmanip_current_mode[0] is 'r'
        \ ? { 's' : 'R', 'c': self.__.fg(self.__color._pink) }
        \ : ''
endfunction

function! s:u.cwd() "{{{1
  let cwd = substitute(getcwd(), expand($HOME), '~', '')
  let cwd = substitute(cwd, '\V~/.vim/bundle/', '[Bundle] ', '')
  let display =
        \ self.__width < 90 ? -15 :
        \ self.__width < 45 ? -10 : 0
  return cwd[ display :  -1 ]
endfunction

function! s:u.smalls() "{{{1
  if !exists('g:smalls_current_mode') | return '' | endif
  let s = g:smalls_current_mode
  if empty(s) | return '' | endif
  return { 's': s,
        \ 'c': ( s is 'exc') ? 'SmallsCurrent' : 'SmallsCandidate' }
endfunction

function! s:u.fugitive() "{{{1
  let s = fugitive#head()
  if s is '' | return '' | endif
  " let branch_symbol = '⎇  '
  " let branch_symbol = '✓ '
  let branch_symbol = "\U2713 "
  if s ==# 'master'
    return { 's': branch_symbol . s }
  else
    return { 's': branch_symbol . s, 'c': self.__.fg(self.__color._warn) }
  endif
endfunction

function! s:u.hide() "{{{1
  for [ limit, parts ] in items(g:ezbar.hide_rule)
    if self.__width < limit
      let self.hide_list += parts
    endif
  endfor
  call filter(self.__layout, 'index(self.hide_list, v:val) ==# -1')
endfunction

function! s:u.__init() "{{{1
  if !self.__active
    return
  endif

  if self.__width < 60
    " let self.__layout =  self.__layout[2:] + [ 'mode' ]
  endif
  " if exists('g:smalls_current_mode') && !empty(g:smalls_current_mode)
  " let self.__layout = [ 'smalls' ]
  " return
  " endif
  let self.hide_list = []
  if get(g:, 'choosewin_active', 0)
    let self.hide_list += [ 'validate' ]
  endif
  call self.hide()
endfunction

function! s:u.__finish() "{{{1
endfunction

function! s:u.__parts_missing(part) "{{{1
endfunction
"}}}

let g:ezbar.parts = s:u
unlet s:u
" vim: foldmethod=marker

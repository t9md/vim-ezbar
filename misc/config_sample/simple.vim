let s:color_theme = {
      \   'active': [
      \     {'gui': [ 'gray3', 'coral1'] },
      \     {'gui': [ 'gray51', 'black'] },
      \     {'gui': [ 'gray21', 'white'] },
      \   ],
      \   'inactive': [
      \     {'gui': [ 'gray25', 'gray61'], 'cterm': [240, 254] },
      \     {'gui': [ 'NavajoWhite1', 'black'] },
      \     {'gui': [ 'NavajoWhite2', 'black'] },
      \     {'gui': [ 'NavajoWhite3', 'black'] },
      \     {'gui': [ 'NavajoWhite4', 'black'] },
      \   ],
      \ }
let g:ezbar_enable      = 1
let g:ezbar             = {}
let g:ezbar.color_theme = s:color_theme
let g:ezbar.separator_L = ''
let g:ezbar.separator_R = '|'
unlet s:color_theme


 "{{{
let g:ezbar.active = [
      \ 'mode',
      \ 'textmanip',
      \ 'smalls',
      \ 'fugitive',
      \ '----',
      \ 'cwd',
      \ '====',
      \ '----',
      \ 'readonly',
      \ 'filename',
      \ 'modified',
      \ 'filetype',
      \ 'encoding',
      \ 'percent',
      \ '----',
      \ 'line_col',
      \ 'winnr',
      \ ]
let g:ezbar.inactive = [
      \ 'modified',
      \ 'filetype',
      \ 'filename',
      \ '====',
      \ 'encoding',
      \ 'winnr',
      \ ]
 " }}}

" let g:ezbar.active =
      " \ 'mode textmanip readonly filename smalls modified filetype fugitive = cwd encoding percent line_col winnr'
" let g:ezbar.inactive =
      " \ 'modified filetype filename = | encoding winnr'
      " " \ { '__SEP__': {}},

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
  if self.__is_active
    let self.__default_color = R.c
  endif
  return R
endfunction

function! s:u.winnr(_) "{{{1
  return printf('win:%2d', a:_)
endfunction "}}}

function! s:u.__SEP(_)
  " call self.__CHANGE_COLOR(a:_)
  let R = {'s': '%=' }
  " if self.__is_active
    " let R.c = self.__parts['mode'].c
  " endif
  return R
endfunction

function! s:u.__color_mode(_)
  let self.__default_color = self.__parts['mode'].c
  return
endfunction

function! s:u.__CHANGE_COLOR(_)
  let self.__default_color = self.__is_active
        \ ? g:ezbar.color_theme.active[self.__color_index]
        \ : g:ezbar.color_theme.inactive[self.__color_index]
  let self.__color_index += 1
  return
endfunction

let s:u['='] = s:u.__SEP
let s:u['===='] = s:u.__SEP

let s:u['|'] = s:u.__CHANGE_COLOR
let s:u['----'] = s:u.__CHANGE_COLOR

function! s:u.textmanip(_) "{{{3
  if !exists('g:textmanip_current_mode') | return '' | endif
  let s = g:textmanip_current_mode[0]
  if s !=# 'r'
    return
  endif
  return { 's' : toupper(s), 'c': {'gui':['DeepPink', 'ivory3'], 'cterm':[ 13, 15] } }
endfunction

function! s:u.cwd(_) "{{{3
  let cwd = substitute(getcwd(), expand($HOME), '~', '')
  let cwd = substitute(cwd, '\V~/.vim/bundle/', '[bundle]', '')
  " let cwd = cwd[-10:-1]
  " if winwidth(0) < 80
    " let cwd = ''
  " endif
  return cwd
endfunction

function! s:u.smalls(_) "{{{3
  if !exists('g:smalls_current_mode') | return '' | endif
  let s = g:smalls_current_mode
  if empty(s)
    return ''
  endif
  let self.__smalls_active = 1
  let color = s == 'excursion' ? 'SmallsCurrent' : 'SmallsCandidate'
  return { 's': s, 'c': color }
endfunction

function! s:u.fugitive(_) "{{{3
  if winwidth(a:_) < 60
    return
  endif
  let s = fugitive#head()
  if s ==# 'master'
    return s
  endif
  return { 's': s, 'c': {'gui': ['OrangeRed2', 'AliceBlue' ] }}
endfunction

function! s:u._init(_) "{{{3
  let self.__color_index = 0
  let self.__smalls_active = 0
endfunction "}}}

function! s:u._finish() "{{{3
  if self.__smalls_active && self.__is_active
    let self.__layout = [self.__parts['smalls']]
  endif
  if has_key(self.__parts, 'filename') && self.__parts.filename.s =~# 'tryit\.'
    let self.__parts.filename.c = { 'gui': ["ForestGreen", "white", "bold"] }
  endif
endfunction


let g:ezbar.parts = extend(ezbar#parts#default#new(), s:u)

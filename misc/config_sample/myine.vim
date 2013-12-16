" EzBar: {{{2
let s:bg = 'gray25'
let g:ezbar = {}
let g:ezbar.active = [
      \ { 'chg_color': {'gui': [ s:bg, 'gray61'] }},
      \ 'mode',
      \ 'textmanip',
      \ 'readonly',
      \ 'filename',
      \ 'smalls',
      \ 'modified',
      \ 'filetype',
      \ 'fugitive',
      \ { '__SEP__': {'gui': [ 'gray22', 'gray61'] }},
      \ 'cwd',
      \ 'encoding',
      \ 'percent',
      \ 'line_col',
      \ ]
let g:ezbar.inactive = [
      \ { 'chg_color': {'gui':[ 'gray22', 'gray57' ]}},
      \ 'modified',
      \ 'filetype',
      \ 'filename',
      \ { '__SEP__': { 'gui': [ 'gray23', 'gray61'] }},
      \ 'encoding',
      \ ]

let s:u = {}
function! s:u.textmanip(_) "{{{3
  let s = toupper(g:textmanip_current_mode[0])
  return { 's' : s, 'c': s == 'R'
        \ ?  {'gui':['DeepPink', 'ivory3' ]}
        \ :  {'gui':[ s:bg, 'PaleGreen1'] }}
endfunction

function! s:u.cwd(_) "{{{3
  let cwd = substitute(getcwd(), expand($HOME), '~', '')
  let cwd = substitute(cwd, '\V~/.vim/bundle/', '[vim-b]', '')
  let cwd = cwd[-10:-1]
  if winwidth(0) < 58
    let cwd = ''
  endif
  return cwd
endfunction

function! s:u.smalls(_) "{{{3
  let s = g:smalls_current_mode
  if empty(s)
    return ''
  endif
  let self.__smalls_active = 1
  let color = s == 'excursion' ? 'SmallsCurrent' : 'SmallsCandidate'
  return { 's': s, 'c': color }
endfunction

function! s:u.fugitive(_) "{{{3
  let s = fugitive#head()
  if empty(s)
    return ''
  endif
  let d =  { 's' : s }
  if s != 'master'
    let d.c = {'gui': ['red4', 'gray61'] }
  endif
  return d
endfunction

function! s:u._filter(layout) "{{{3
  if self.__smalls_active && self.__is_active
    return filter(a:layout, 'v:val.name == "smalls"')
  endif
  return a:layout
endfunction

function! s:u._init() "{{{3
  let self.__smalls_active = 0
endfunction "}}}

let g:ezbar.parts = extend(ezbar#parts#default#new(), s:u)
unlet s:u

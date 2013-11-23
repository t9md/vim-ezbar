let s:bg = 'gray25'

let g:ezbar = {}
let g:ezbar.active = {}                      
let g:ezbar.active.default_color = [ s:bg, 'gray61']
let g:ezbar.active.sep_color = [ 'gray30', 'gray61']
let g:ezbar.inactive = {}
let g:ezbar.inactive.default_color = [ 'gray18', 'gray57' ]
let g:ezbar.inactive.sep_color = [ 'gray23', 'gray61']
let g:ezbar.active.layout = [
      \ 'mode',
      \ 'textmanip',
      \ 'smalls',
      \ 'modified',
      \ 'filetype',
      \ 'fugitive',
      \ '__SEP__',
      \ 'encoding',
      \ 'percent',
      \ 'line_col',
      \ ]
let g:ezbar.inactive.layout = [
      \ 'modified',
      \ 'filename',
      \ '__SEP__',
      \ 'encoding',
      \ 'percent',
      \ ]

let u = {}
function! u.textmanip() "{{{1
  return toupper(g:textmanip_current_mode[0])
endfunction
function! u.smalls() "{{{1
  let s = toupper(g:smalls_current_mode[0])
  if empty(s)
    return ''
  endif
  let self.__smalls_active = 1
  let color = s == 'E' ? 'SmallsCurrent' : 'SmallsCandidate'
  return { 's' : 's', 'c': color }
endfunction

function! u.fugitive() "{{{1
  return fugitive#head()
endfunction

" `_init()` is special function, if `g:ezbar.parts._init` is function.
" use this to define some field to store state.
function! u._init() "{{{1
  let self.__smalls_active = 0
endfunction

" `_filter()` is special function, if `g:ezbar.parts._filter` is function.
" ezbar call this function with normalized layout as argument.
function! u._filter(layout) "{{{1
  if self.__smalls_active && self.__is_active
    " fill statusline when smalls is active
    return filter(a:layout, 'v:val.name == "smalls"')
  endif

  let r =  []
  " you can decorate color here instead of in each part function.
  for part in a:layout
    if part.name == 'fugitive'
      let part.c = part.s == 'master' ?  ['gray18', 'gray61'] : ['red4', 'gray61']
    elseif part.name == 'textmanip'
      let part.c = part.s == 'R' ? [ s:bg, 'HotPink1'] :  [ s:bg, 'PaleGreen1']
    endif
    call add(r, part)
  endfor
  return r
endfunction

let g:ezbar.parts = extend(ezbar#parts#default#new(), u)
unlet u

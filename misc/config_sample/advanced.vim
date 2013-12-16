let s:bg = 'gray25'

function! s:GUI(...)
  return { 'gui': a:000 }
endfunction

let g:ezbar = {}
let g:ezbar.active = [
      \ { 'chg_color': s:GUI( s:bg, 'gray61') },
      \ 'mode',
      \ 'textmanip',
      \ 'smalls',
      \ 'modified',
      \ 'filetype',
      \ 'fugitive',
      \ { '__SEP__': s:GUI('gray30', 'gray61') },
      \ 'encoding',
      \ 'percent',
      \ 'line_col',
      \ ]
let g:ezbar.inactive = [
      \ { 'chg_color': s:GUI('gray18', 'gray57')},
      \ 'modified',
      \ 'filename',
      \ { '__SEP__': s:GUI('gray23', 'gray61') },
      \ 'encoding',
      \ 'percent',
      \ ]

let s:u = {}

function! s:u.textmanip(_) "{{{1
  return toupper(g:textmanip_current_mode[0])
endfunction

function! s:u.smalls(_) "{{{1
  let s = toupper(g:smalls_current_mode[0])
  if empty(s)
    return ''
  endif
  let self.__smalls_active = 1
  return { 's' : 's', 'c': s == 'E' ? 'SmallsCurrent' : 'SmallsCandidate' }
endfunction

function! s:u.fugitive(_) "{{{1
  return fugitive#head()
endfunction

" `_init()` is special function, if `g:ezbar.parts._init` is function.
" use this to define some field to store state.
function! s:u._init() "{{{1
  let self.__smalls_active = 0
endfunction

" `_filter()` is special function, if `g:ezbar.parts._filter` is function.
" ezbar call this function with normalized layout as argument.
function! s:u._filter(layout) "{{{1
  if self.__smalls_active && self.__is_active
    " fill statusline when smalls is active
    return filter(a:layout, 'v:val.name == "smalls"')
  endif

  let r =  []
  " you can decorate color here instead of in each part function.
  for part in a:layout
    if part.name == 'fugitive'
      let part.c = part.s == 'master' ? s:GUI('gray18', 'gray61') : s:GUI('red4', 'gray61')
    elseif part.name == 'textmanip'
      let part.c = part.s == 'R' ? s:GUI(s:bg, 'HotPink1') : s:GUI(s:bg, 'PaleGreen1')
    endif
    call add(r, part)
  endfor
  return r
endfunction

let g:ezbar.parts = extend(ezbar#parts#default#new(), s:u)
unlet s:u

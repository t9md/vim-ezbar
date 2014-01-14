let s:bg = 'gray25'
let s:c = {
      \ 'L_act':    { 'gui': [ s:bg,     'gray61']     },
      \ 'L_inact':  { 'gui': [ 'gray22', 'gray57']     },
      \ 'SEP_act':  { 'gui': [ 'gray22', 'gray61']     },
      \ 'SEP_inact':{ 'gui': [ 'gray23', 'gray61']     },
      \ 'STANDOUT': { 'gui': [ s:bg,     'HotPink1']   },
      \ 'NORMAL':   { 'gui': [ s:bg,     'PaleGreen1'] },
      \ 'WARNING':  { 'gui': ['red4',    'gray61']     },
      \ }

let g:ezbar = {}
let g:ezbar.active = [
      \ { 'chg_color': s:c.L_act} ,
      \ 'mode',
      \ 'textmanip',
      \ 'smalls',
      \ 'modified',
      \ 'filetype',
      \ 'fugitive',
      \ { '__SEP__': s:c.SEP_act },
      \ 'encoding',
      \ 'percent',
      \ 'line_col',
      \ ]
let g:ezbar.inactive = [
      \ {'chg_color': s:c.L_inact },
      \ 'modified',
      \ 'filename',
      \ { '__SEP__': s:c.SEP_inact },
      \ 'encoding',
      \ 'percent',
      \ ]

let s:u = {}
function! s:u.textmanip(_) "{{{1
  let s = toupper(g:textmanip_current_mode[0])
  return { 's' : s, 'c': s == 'R' ? s:c.STANDOUT : s:c.NORMAL }
endfunction

function! s:u.smalls(_) "{{{1
  let s = toupper(g:smalls_current_mode[0])
  if empty(s)
    return ''
  endif
  return { 's' : 'smalls-' . s, 'c':
        \ s == 'E' ? 'SmallsCurrent' : 'Function' }
endfunction

function! s:u.fugitive(_) "{{{1
  let s = fugitive#head()
  return { 's': s, 'c': s !=# 'master' ? s:c.WARNING : ''  }
endfunction

let g:ezbar.parts = extend(ezbar#parts#default#new(), s:u)
unlet s:u

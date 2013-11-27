let s:bg = 'gray25'
let s:c = {
      \ 'act_L':         { 'gui': [ s:bg,     'gray61']     },
      \ 'act_SEP':       { 'gui': [ 'gray22', 'gray61']     },
      \ 'inact_L':       { 'gui': [ 'gray22', 'gray57']    },
      \ 'inact_SEP':     { 'gui': [ 'gray23', 'gray61']     },
      \ 'plug_STANDOUT': { 'gui': [ s:bg,     'HotPink1']   },
      \ 'plug_NORMAL':   { 'gui': [ s:bg,     'PaleGreen1'] },
      \ 'plug_WARNING':  { 'gui': ['red4',    'gray61']     },
      \ }


let g:ezbar = {}
let g:ezbar.active = [
      \ { 'chg_color': s:c.act_L} ,
      \ 'mode',
      \ 'textmanip',
      \ 'smalls',
      \ 'modified',
      \ 'filetype',
      \ 'fugitive',
      \ { '__SEP__': s:c.act_SEP },
      \ 'encoding',
      \ 'percent',
      \ 'line_col',
      \ ]
let g:ezbar.inactive = [
      \ {'chg_color': s:c.inact_L },
      \ 'modified',
      \ 'filename',
      \ { '__SEP__': s:c.inact_SEP },
      \ 'encoding',
      \ 'percent',
      \ ]

let s:u = {}
function! s:u.textmanip() "{{{1
  let s = toupper(g:textmanip_current_mode[0])
  return { 's' : s, 'c': s == 'R'
        \ ? s:c.plug_STANDOUT
        \ : s:c.plug_NORMAL }
endfunction

function! s:u.smalls() "{{{1
  let s = toupper(g:smalls_current_mode[0])
  if empty(s)
    return ''
  endif
  return { 's' : 'smalls-' . s, 'c':
        \ s == 'E' ? 'SmallsCurrent' : 'Function' }
endfunction

function! s:u.fugitive() "{{{1
  let s = fugitive#head()
  if empty(s)
    return ''
  endif
  return { 's' : s, 'c': (s != 'master') ? s:c.plug_WARNING : '' }
endfunction

let g:ezbar.parts = extend(ezbar#parts#default#new(), s:u)
unlet! s:u

" echo ezbar#string()
" nnoremap <F9> :<C-u>EzBarUpdate<CR>


let s:bg = 'gray25'

let g:ezbar = {}
let g:ezbar.active = [
      \ [ s:bg, 'gray61'],
      \ 'mode',
      \ 'textmanip',
      \ 'smalls',
      \ 'modified',
      \ 'filetype',
      \ 'fugitive',
      \ { '__SEP__': [ 'gray22', 'gray61'] },
      \ 'encoding',
      \ 'percent',
      \ 'line_col',
      \ ]
let g:ezbar.inactive = [
      \ [ 'gray22', 'gray57' ],
      \ 'modified',
      \ 'filename',
      \ { '__SEP__': [ 'gray23', 'gray61'] },
      \ 'encoding',
      \ 'percent',
      \ ]

let u = {}
function! u.textmanip() "{{{1
  let s = toupper(g:textmanip_current_mode[0])
  return { 's' : s, 'c': s == 'R'
        \ ?  [ s:bg, 'HotPink1']
        \ :  [ s:bg, 'PaleGreen1'] }
endfunction
function! u.smalls() "{{{1
  let s = toupper(g:smalls_current_mode[0])
  if empty(s)
    return ''
  endif
  return { 's' : 'smalls-' . s, 'c':
        \ s == 'E' ? 'SmallsCurrent' : 'Function' }
endfunction

function! u.fugitive() "{{{1
  let s = fugitive#head()
  if empty(s)
    return ''
  endif
  return { 's' : s, 'c': s == 'master'
        \ ?  ['gray18', 'gray61']
        \ :  ['red4', 'gray61']
        \ }
        " \ ?  ['red4', 'gray61']
endfunction
" function! u._filter(layout) "{{{1
  " echo len(a:layout)
" endfunction

let g:ezbar.parts = extend(ezbar#parts#default#new(), u)
unlet u

" echo ezbar#string()
nnoremap <F9> :<C-u>EzBarUpdate<CR>


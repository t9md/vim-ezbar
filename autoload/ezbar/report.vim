" Util:
let s:TYPE_STRING = type('')
function! s:uniq(list) "{{{1
  let R = {}
  for l in a:list
    let R[l] = 1
  endfor
  return keys(R)
endfunction

function! s:included(l1, l2) "{{{1
  " included in l1 of l2 item
  return filter(copy(a:l2), 'index(a:l1, v:val) != -1')
endfunction

function! s:not_included(l1, l2) "{{{1
  " no_included in l1 of l2 item
  return filter(copy(a:l2), 'index(a:l1, v:val) == -1')
endfunction

function! s:split_if_string(arg)
  return type(a:arg) ==# s:TYPE_STRING
        \ ? split(a:arg) : a:arg
endfunction
"}}}

" Body:
let s:report = {}
function! s:report.run(parts_default, parts_user, ezbar) "{{{1
  let layout_all = []
  let used = s:uniq(
        \ s:split_if_string(a:ezbar.active)
        \ + s:split_if_string(a:ezbar.inactive) )
  echo "==== Used in layout"
  echo used
  echo ''
  echo "==== NOT Used in layout"
  echo s:not_included(used, keys(a:parts_user))
  echo ''
  echo "==== Overritten default_parts"
  echo  s:included(keys(a:parts_default), keys(a:parts_user))
  echo ''
  echo "==== Depending on default_parts"
  echo s:not_included(keys(a:parts_user), used)
  echo ''
  echo "==== Original parts"
  echo s:not_included(keys(a:parts_default), keys(a:parts_user))
  echo ''
endfunction

function! ezbar#report#run(...) "{{{1
  call call(s:report.run, a:000, s:report)
endfunction
"}}}

" Example: s:u is user_defined parts before merged
" call ezbar#report#run(ezbar#parts#default#new(), s:u, g:ezbar)

" vim: foldmethod=marker

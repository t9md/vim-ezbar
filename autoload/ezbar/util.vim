function! s:SID() "{{{1
  let fullname = expand("<sfile>")
  return matchstr(fullname, '<SNR>\d\+_')
endfunction
"}}}
let s:sid = s:SID()
"}}}

function! s:debug(msg) "{{{1
  if !get(g:,'ezbar_debug')
    return
  endif
  if exists('*Plog')
    call Plog(a:msg)
  endif
endfunction

function! s:define_type_checker() "{{{1
  " dynamically define s:is_Number(v)  etc..
  let types = {
        \ "Number":     0,
        \ "String":     1,
        \ "Funcref":    2,
        \ "List":       3,
        \ "Dictionary": 4,
        \ "Float":      5,
        \ }

  for [type, number] in items(types)
    let s = ''
    let s .= 'function! s:is_' . type . '(v)' . "\n"
    let s .= '  return type(a:v) is ' . number . "\n"
    let s .= 'endfunction' . "\n"
    execute s
  endfor
endfunction
"}}}
call s:define_type_checker()
unlet! s:define_type_checker

function! s:screen_type() "{{{1
  return has('gui_running') ? 'gui' : 'cterm'
endfunction
"}}}

let s:functions = [
      \ "debug",
      \ "screen_type",
      \ "is_Number",
      \ "is_String",
      \ "is_Funcref",
      \ "is_List",
      \ "is_Dictionary",
      \ "is_Float",
      \ ]

function! ezbar#util#get() "{{{1
  let R = {}
  for fname in s:functions
    let R[fname] = function(s:sid . fname)
  endfor
  return R
endfunction
"}}}

" vim: foldmethod=marker

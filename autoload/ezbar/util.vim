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


function! s:buffer_options_set(bufnr, options) "{{{1
  let R = {}
  for [var, val] in items(a:options)
    let R[var] = getbufvar(a:bufnr, var)
    call setbufvar(a:bufnr, var, val)
    unlet var val
  endfor
  return R
endfunction

function! s:window_options_set(winnr, options) "{{{1
  let R = {}
  for [var, val] in items(a:options)
    let R[var] = getwinvar(a:winnr, var)
    call setwinvar(a:winnr, var, val)
    unlet var val
  endfor
  return R
endfunction
"}}}

function! s:str_split(str) "{{{1
  return split(a:str, '\zs')
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
      \ "str_split",
      \ "screen_type",
      \ "buffer_options_set",
      \ "window_options_set",
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

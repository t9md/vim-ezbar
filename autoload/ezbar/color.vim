" This file is not essential part of ezbar.
" Provide utilities to manage color.
" Should be work without this file.

let s:_        = ezbar#util#get()
let s:SCREEN   = s:_.screen_type()
let s:RGB_data = expand("$VIMRUNTIME/rgb.txt")

function! s:read_RGB() "{{{1
  let lines = readfile(s:RGB_data)
  call filter(lines, "v:val !~# '^\s*\d'")
  return filter(lines, 'len(split(v:val)) is# 4')
endfunction
"}}}

" API:
function! ezbar#color#highlight_names() "{{{1
  let mgr = ezbar#hlmanager()
  let RGB = ezbar#color#name2rgb()
  for [name, rgb] in items(RGB)
    let cname = mgr.register({ s:SCREEN : ['#'.rgb , '#000000'] })
    call matchadd(cname, '\<' .name .'\>')
    call matchadd(cname, '\V' . rgb)
  endfor
endfunction

function! ezbar#color#check() range "{{{1
  let mgr = ezbar#hlmanager()
  let color_def_pat = '\v\{\s*''(gui|cterm)''\s*:\s*\[.{-}\]\s*}'
  call map(
        \ filter(getmatches(), 'v:val.group =~# "EzBar"'),
        \ 'matchdelete(v:val.id)')

  for n in range(a:firstline, a:lastline)
    let color = matchstr(getline(n), color_def_pat)
    if empty(color)
      continue
    endif
    call matchadd(mgr.register(eval(color)), '\V' . color)
  endfor
endfunction

function! ezbar#color#list() "{{{1
  return map(s:read_RGB(), 'split(v:val)[-1]')
endfunction

function! ezbar#color#capture(color) "{{{1
  let mgr = ezbar#hlmanager()
  call setreg(
        \ v:register,
        \ string(mgr.convert_full(a:color)),
        \ 'V')
endfunction

function! ezbar#color#name2rgb() "{{{1
  let R = {}
  for line in s:read_RGB()
    let [r, g, b, name] = split(line)
    let R[name] = printf("%02x%02x%02x", r, g, b)
  endfor
  return R
endfunction
"}}}

" vim: foldmethod=marker

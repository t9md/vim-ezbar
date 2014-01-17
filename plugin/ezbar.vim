" GUARD:
if expand("%:p") ==# expand("<sfile>:p") | unlet! g:loaded_ezbar | endif
if exists('g:loaded_ezbar') | finish | endif
let g:loaded_ezbar = 1
let s:old_cpo = &cpo
set cpo&vim

" Main:
let s:options = {
      \ 'g:ezbar':        {},
      \ 'g:ezbar_enable': 1,
      \ }
let s:default_config
      \ = expand('<sfile>:h:h') . '/autoload/ezbar/config/default.vim'

function! s:set_options(options) "{{{
  for [varname, value] in items(a:options)
    if !exists(varname)
      let {varname} = value
    endif
    unlet value
  endfor
endfunction

function! s:startup() "{{{1
  if !g:ezbar_enable
    return
  endif

  if empty(g:ezbar)
    execute 'source' s:default_config
  endif
  call ezbar#enable()
endfunction
"}}}

call s:set_options(s:options)
call s:startup()

" Command:
command! EzBarDisable call ezbar#disable()
command! EzBarEnable  call ezbar#enable()

command! -range EzBarColorCheck
      \ :<line1>,<line2>call ezbar#color_check()
command! -nargs=1 -complete=highlight
      \ EzBarColorCapture call ezbar#color_capture(<f-args>)

" Finish:
let &cpo = s:old_cpo
" vim: foldmethod=marker

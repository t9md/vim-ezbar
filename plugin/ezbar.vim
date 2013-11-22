" GUARD:
if exists('g:loaded_ezbar')
  " finish
endif
let g:loaded_ezbar = 1
let s:old_cpo = &cpo
set cpo&vim

" Main:
let options = {
      \ 'g:ezbar' : {},
      \ }
      
function! s:set_options(options) "{{{
  for [varname, value] in items(a:options)
    if !exists(varname)
      let {varname} = value
    endif
    unlet value
  endfor
endfunction "}}}
call s:set_options(options)

" AutoCmd:
augroup EzBar
  autocmd!
  autocmd WinEnter,BufWinEnter,FileType,ColorScheme * call ezbar#set()
  autocmd ColorScheme,SessionLoadPost * call ezbar#hl_refresh()
  " autocmd CursorMoved,BufUnload * call 
augroup END
" KeyMap:
" nnoremap <silent> <Plug>(ezbar-debug)    :<C-u>call smalls#debug(1)<CR>

" Command:
command! EzBar call ezbar#set()
command! EzBarUpdate call ezbar#update()
command! EzBarSet call ezbar#set()
command! EzBarDefaultFunctionNames echo ezbar#functions#default_names()
command! -range EzBarColorPreview 
      \ :call ezbar#highlighter#preview(<line1>, <line2>)

" Finish:
let &cpo = s:old_cpo
" vim: foldmethod=marker


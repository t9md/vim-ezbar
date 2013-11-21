" GUARD:
if exists('g:loaded_easy_statusline')
  " finish
endif
let g:loaded_easy_statusline = 1
let s:old_cpo = &cpo
set cpo&vim

" Main:
let options = {
      \ 'g:easy_statusline' : {},
      \ }
      
function! s:set_options(options) "{{{
  for [varname, value] in items(a:options)
    if !exists(varname)
      let {varname} = value
    endif
    unlet value
  endfor
endfunction "}}}
function! s:clear_highlight(color) "{{{1
  for color in keys(a:color)
    exe 'highlight' color 'none'
  endfor
endfunction

function! s:set_color(colors) "{{{1
  let s = 'highlight! %s cterm=%s ctermbg=%s ctermfg=%s gui=%s guibg=%s guifg=%s'
  for [k, v] in items(a:colors)
    let [c, g] = v
    let arg = [s] + [k] + c + g
    exe call(function('printf'), arg)
  endfor
endfunction

function! s:set_highlight() "{{{1
  call s:clear_highlight(s:color)
  call s:set_color(s:color)
  highlight link SmallsRegion Visual
endfunction "}}}

call s:set_options(options)

" AutoCmd:
augroup EasyStatusLine
  autocmd!
  " autocmd WinEnter,BufWinEnter,FileType,ColorScheme * call easy_statusline#set()
  " autocmd ColorScheme,SessionLoadPost * call easy_statusline#hl()
  " autocmd CursorMoved,BufUnload * call 
augroup END
" KeyMap:
" nnoremap <silent> <Plug>(easy_statusline-debug)    :<C-u>call smalls#debug(1)<CR>

" Command:
command! EasyStatusLine call easy_statusline#set()
command! EasyStatusLineDefaultFunctionNames echo easy_statusline#functions#default_names()

" Finish:
let &cpo = s:old_cpo
" vim: foldmethod=marker


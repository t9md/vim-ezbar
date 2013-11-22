let g:ezbar = {}
let g:ezbar.active = {}                      
let g:ezbar.active.default_color = 'StatusLine'
let g:ezbar.active.layout = [
      \ '_mode',
      \ '_filename',
      \ '_modified',
      \ '_filetype',
      \ 'textmanip',
      \ 'smalls',
      \ 'fugitive',
      \ '__SEP__',
      \ '_encoding',
      \ '_percent',
      \ '_line_col',
      \ ]
let g:ezbar.inactive = {}
let g:ezbar.inactive.default_color = 'StatusLineNC'
let g:ezbar.inactive.layout = [
      \ '_modified',
      \ '_filename',
      \ '_filetype',
      \ '__SEP__',
      \ '_encoding',
      \ '_percent',
      \ ]
let g:ezbar.functions = {}
let u = {}
function! u.textmanip() "{{{1
  let s = toupper(g:textmanip_current_mode[0])
  return { 's' : s, 'c': s == 'R' ? 'Statement' : 'Function' }
endfunction
function! u.smalls() "{{{1
  let s = toupper(g:smalls_current_mode[0])
  if empty(s)
    return ''
  endif
  return { 's' : 'smalls-' . s, 'c': s == 'E' ? 'SmallsCurrent' : 'Function' }
endfunction
function! u.fugitive() "{{{1
  let s = fugitive#head()
  if empty(s)
    return ''
  endif
  return { 's' : s, 'c': s == 'master' ? 'Normal' : 'SmallsCurrent' }
endfunction
let g:ezbar.functions = u
" echo ezbar#string()
nnoremap <F9> :<C-u>EzBarUpdate<CR>


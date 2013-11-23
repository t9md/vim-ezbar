function! s:plog(msg) "{{{1
  cal vimproc#system('echo "' . PP(a:msg) . '" >> ~/vim.log')
endfunction
let g:ezbar = {}
let g:ezbar.active = {}                      
let s:bg = 'gray25'
let g:ezbar.active.default_color = [ s:bg, 'gray61']
let g:ezbar.active.sep_color = [ 'gray30', 'gray61']
let g:ezbar.inactive = {}
let g:ezbar.inactive.default_color = [ 'gray18', 'gray57' ]
let g:ezbar.inactive.sep_color = [ 'gray23', 'gray61']
let g:ezbar.active.layout = [
      \ 'mode',
      \ 'textmanip',
      \ 'smalls',
      \ 'modified',
      \ 'filetype',
      \ 'fugitive',
      \ '__SEP__',
      \ 'encoding',
      \ 'percent',
      \ 'line_col',
      \ ]
let g:ezbar.inactive.layout = [
      \ 'modified',
      \ 'filename',
      \ '__SEP__',
      \ 'encoding',
      \ 'percent',
      \ ]

let u = {}
function! u.textmanip() "{{{1
  return toupper(g:textmanip_current_mode[0])
endfunction
function! u.smalls() "{{{1
  let self.__smalls_active = 0
  let s = toupper(g:smalls_current_mode[0])
  if empty(s)
    return ''
  endif
  let self.__smalls_active = 1
  let color = s == 'E' ? 'SmallsCurrent' : 'SmallsCandidate'
  return { 's' : 's', 'c': color }
endfunction

function! u.fugitive() "{{{1
  return fugitive#head()
endfunction

function! u._filter(layout) "{{{1
  let r =  []
  let names = []
  if self.__smalls_active
    " fill statusline when smalls is active
    return filter(a:layout, 'v:val.name == "smalls"')
  endif
  for part in a:layout
    call add(names, part.name)
    if part.name == 'fugitive'
      let part.c = part.s == 'master' ?  ['gray18', 'gray61'] : ['red4', 'gray61']
    endif
    if part.name == 'textmanip'
      let part.c = part.s == 'R' ? [ s:bg, 'HotPink1'] :  [ s:bg, 'PaleGreen1']
    endif
    call add(r, part)
  endfor
  return r
endfunction

let g:ezbar.parts = extend(ezbar#parts#default#new(), u)
unlet u

" echo ezbar#string()
nnoremap <F9> :<C-u>EzBarUpdate<CR>


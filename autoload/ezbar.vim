" Utility:
function! s:plog(msg) "{{{1
  cal vimproc#system('echo "' . PP(a:msg) . '" >> ~/vim.log')
endfunction "}}}

function! s:extract_color_definition(string) "{{{1
  return matchstr(a:string, '\v\{\s*''(gui|cterm)''\s*:\s*\[.{-}\]\s*}')
endfunction
"}}}

" Main:
let s:TYPE_STRING     = type('')
let s:TYPE_DICTIONARY = type({})
let s:TYPE_NUMBER     = type(0)

let s:ez = {}

function! s:ez.init() "{{{1
  let self.highlight = ezbar#highlighter#new('EzBar')
endfunction

function! s:ez.prepare(win, winnum) "{{{1
  let g:ezbar.parts.__is_active = ( a:win ==# 'active' )
  let g:ezbar.parts.__default_color =
        \ ( a:win ==# 'active' ) ? 'StatusLine' : 'StatusLineNC'

  " Init:
  if exists('*g:ezbar.parts._init')
    call g:ezbar.parts._init(a:winnum)
  endif

  " Normalize:
  let layout = map( deepcopy(g:ezbar[a:win]),
        \ 'self.normalize_part(a:win, v:val, a:winnum)')

  " Eliminate:
  call filter(layout, '!empty(v:val)')
  call filter(layout, '!empty(v:val.s)')

  let parts = {}
  for part in layout
    let parts[part.name] = part
  endfor

  " Filter:
  if exists('*g:ezbar.parts._filter')
    let layout = g:ezbar.parts._filter(layout, parts)
  endif
  return layout
endfunction

" function! s:ez.color_set(win, color) "{{{1
  " let self['color_' . a:win] = a:color
" endfunction

" function! s:ez.color_get(win) "{{{1
  " return copy(self['color_' . a:win])
" endfunction

function! s:ez.normalize_part(win, part_name, winnum) "{{{1
  let TYPE_part_name = type(a:part_name)
  if TYPE_part_name is s:TYPE_STRING
    let part = g:ezbar.parts[a:part_name](a:winnum)
  elseif TYPE_part_name is s:TYPE_DICTIONARY
    if has_key(a:part_name, 'chg_color')
      let g:ezbar.parts.__default_color = a:part_name['chg_color']
      " call self.color_set(a:win, a:part_name['chg_color'])
      return
    elseif has_key(a:part_name, '__SEP__')
      let part = { 'name': '__SEP__', 's': '%=', 'c': a:part_name['__SEP__'] }
    else
      return
    endif
  endif

  let TYPE_part = type(part)
  " not supported if part type is not Dict nor String.
  if TYPE_part is s:TYPE_DICTIONARY
    let DICT = part
  elseif TYPE_part is s:TYPE_STRING || TYPE_part is s:TYPE_NUMBER
    let DICT = { 's' : part }
  else
    return
  endif

  if empty(get(DICT, 'c')) 
    let DICT.c = copy(g:ezbar.parts.__default_color)
    " let DICT.c = self.color_get(a:win)
  endif

  if !has_key(DICT, 'name')
    let DICT.name = a:part_name
  endif
  return DICT
endfunction

function! s:ez.color_of(win, part) "{{{1
  let color = get(a:part, (a:win ==# 'active' ? 'ac' : 'ic' ), a:part.c)
  return self.highlight.register(color)
endfunction

function! s:ez.string(win, winnum) "{{{1
  " let self.color_active   = 'StatusLine'
  " let self.color_inactive = 'StatusLineNC'
  let self.separator_L    = get(g:ezbar, 'separator_L', '|')
  let self.separator_R    = get(g:ezbar, 'separator_R', '|')

  let RESULT = ''

  let self.section = 'L'
  let layout = self.prepare(a:win, a:winnum)
  let layout_len = len(layout)

  for idx in range(layout_len)
    unlet! part
    let part    = layout[idx]
    let color   = self.color_of(a:win, part)
    let color_s = '%#' . color . '#'
    let s = printf('%%#%s# %s ', color, part.s)

    if part.s ==# '%='
      let self.section = 'R'
      let RESULT .= s
      continue
    endif

    let next = idx + 1
    if next != layout_len && color ==# self.color_of(a:win, layout[next])
      let s .= self['separator_' . self.section]
    endif
    let RESULT .= s
  endfor
  return RESULT
endfunction
"}}}

" Public:
function! ezbar#string(win, winnum) "{{{1
  return s:ez.string(a:win, a:winnum)
endfunction

function! ezbar#set() "{{{1
  for n in range(1, winnr('$'))
    if n ==# winnr()
      call setwinvar(n, '&statusline', '%!ezbar#string("active", ' . n . ')')
    else
      call setwinvar(n, '&statusline', '%!ezbar#string("inactive", ' . n . ')')
    endif
  endfor
endfunction

function! ezbar#update() "{{{1
  " for test purpose
  call setwinvar(winnr(), '&statusline', '%!ezbar#string("active", ' . winnr() . ')')
endfunction

function! ezbar#hl_refresh() "{{{1
  call s:ez.highlight.refresh()
endfunction


function! ezbar#disable() "{{{1
  silent set statusline&

  for tab in range(1, tabpagenr('$'))
    for win in range(1, tabpagewinnr(tab, '$'))
      call settabwinvar(tab, win, '&statusline', &statusline)
    endfor
  endfor

  augroup plugin-ezbar
    autocmd!
  augroup END
endfunction

" function! ezbar#change_color(win, color) "{{{1
  " call s:ez.color_set(a:win, a:color)
" endfunction

function! ezbar#enable() "{{{1
  augroup plugin-ezbar
    autocmd!
    autocmd WinEnter,BufWinEnter,FileType,ColorScheme * call ezbar#set()
    autocmd ColorScheme,SessionLoadPost * call ezbar#hl_refresh()
  augroup END
endfunction

function! ezbar#check_highlight() range "{{{1
  " clear
  call map(
        \ filter(getmatches(), 'v:val.group =~# "EzBar"'),
        \ 'matchdelete((v:val.id)')

  for n in range(a:firstline, a:lastline)
    let color = s:extract_color_definition(getline(n))
    if empty(color) | continue | endif
    call matchadd(s:ez.highlight.register(eval(color)), '\V' . color)
  endfor
endfunction
"}}}

call s:ez.init()

if expand("%:p") !=# expand("<sfile>:p")
  finish
endif
" echo s:ez.string('active', winnr())
" echo s:ez.string('inactive')

" vim: foldmethod=marker

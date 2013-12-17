" Utility:
function! s:plog(msg) "{{{1
  cal vimproc#system('echo "' . PP(a:msg) . '" >> ~/vim.log')
endfunction "}}}
function! s:gather_matchid_for(hlgroup) "{{{1
  return map(filter(getmatches(), "v:val.group =~# '". a:hlgroup . "'"),
        \ 'v:val.id')
endfunction
"}}}

" Main:
let s:ez = {}

function! s:ez.init() "{{{1
  let self.color_active   = 'StatusLine'
  let self.color_inactive = 'StatusLineNC'
  let self.separator_L    = get(g:ezbar, 'separator_L',  '|')
  let self.separator_R    = get(g:ezbar, 'separator_R', '|')
  let self.highlight = ezbar#highlighter#new('EzBar')
endfunction

function! s:ez.prepare(win, winnum) "{{{1
  let g:ezbar.parts.__is_active = ( a:win ==# 'active' )

  if exists('*g:ezbar.parts._init')
    call g:ezbar.parts._init()
  endif

  let layout = map( deepcopy(g:ezbar[a:win]),
        \ 'self.normalize_part(a:win, v:val, a:winnum)')

  call filter(layout, '!empty(v:val)')
  call filter(layout, '!empty(v:val.s)')

  if exists('*g:ezbar.parts._filter')
    let layout = g:ezbar.parts._filter(layout)
  endif
  return layout
endfunction

function! s:ez.color_set(win, color) "{{{1
  let self['color_' . a:win] = a:color
endfunction

function! s:ez.color_get(win) "{{{1
  return self['color_' . a:win]
endfunction

function! s:ez.normalize_part(win, part_name, winnum) "{{{1
  if type(a:part_name) ==# type('')
    let part = g:ezbar.parts[a:part_name](a:winnum)
  elseif type(a:part_name) ==# type({})
    if has_key(a:part_name, 'chg_color')
      call self.color_set(a:win, a:part_name['chg_color'])
      return
    elseif has_key(a:part_name, '__SEP__')
      let part = { 'name': '__SEP__', 's': '%=', 'c': a:part_name['__SEP__'] }
    else
      return
    endif
  endif

  " not supported if part type is not Dict nor String.
  if type(part) == type({})
    let DICT = part
  elseif type(part) == type('')
    let DICT = { 's' : part }
  else
    return
  endif

  if empty(get(DICT, 'c')) 
    let DICT.c = self.color_get(a:win)
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

function! ezbar#get_highlighter() "{{{1
  return s:ez.highlight
endfunction

function! ezbar#disable() "{{{1
  silent set statusline&
  for n in range(1, winnr('$'))
    call setwinvar(n, '&statusline', &statusline)
  endfor

  augroup plugin-ezbar
    autocmd!
  augroup END
endfunction
function! ezbar#enable() "{{{1
  augroup plugin-ezbar
    autocmd!
    autocmd WinEnter,BufWinEnter,FileType,ColorScheme * call ezbar#set()
    autocmd ColorScheme,SessionLoadPost * call ezbar#hl_refresh()
  augroup END
endfunction

function! ezbar#check_highlight() range "{{{1
  for id in s:gather_matchid_for('EzBar')
    call matchdelete(id)
  endfor

  for n in range(a:firstline, a:lastline)
    let color = matchstr(getline(n), '\v\{\s*''(gui|cterm)''\s*:\s*\[.{-}\]\s*}')
    if !empty(color)
      let hlname = s:ez.highlight.register(eval(color))
      call matchadd(hlname, '\V' . color)
    endif
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

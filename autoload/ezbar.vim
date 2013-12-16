function! s:plog(msg) "{{{1
  cal vimproc#system('echo "' . PP(a:msg) . '" >> ~/vim.log')
endfunction "}}}

let s:ez = {}
function! s:ez.init() "{{{1
  let self.default_color = {}
  let self.default_color.active   = 'StatusLine'
  let self.default_color.inactive = 'StatusLineNC'
  let self.hl = ezbar#highlighter#new('EzBar')
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

function! s:ez.normalize_part(win, part_name, winnum) "{{{1
  if type(a:part_name) ==# type('')
    let part = g:ezbar.parts[a:part_name](a:winnum)

  elseif type(a:part_name) ==# type({})
    if has_key(a:part_name, 'chg_color')
      let self.default_color[a:win] = a:part_name['chg_color']
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
    let DICT.c = self.default_color[a:win]
  endif
  if !has_key(DICT, 'name')
    let DICT.name = a:part_name
  endif

  return DICT
endfunction

function! s:ez.color_of(win, part)
  let color = get(a:part, (a:win ==# 'active' ? 'ac' : 'ic' ), a:part.c)
  return self.hl.register(color)
endfunction

function! s:ez.string(win, winnum) "{{{1
  let RESULT = ''

  let self.current_sec = 'left'
  let layout = self.prepare(a:win, a:winnum)
  let layout_len = len(layout)

  for idx in range(layout_len)
    unlet! part
    let part    = layout[idx]
    let color   = self.color_of(a:win, part)
    let color_s = '%#' . color . '#'
    let s = color_s . ' ' . part.s . ' '

    if part.s ==# '%='
      let self.current_sec = 'right'
      let RESULT .= s
      continue
    endif

    let next = idx + 1
    if next != layout_len && color ==# self.color_of(a:win, layout[next])
      let s .= '|'
    endif
    let RESULT .= s
  endfor
  return RESULT
endfunction

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
  call s:ez.hl.refresh()
endfunction

function! ezbar#hl_preview(first, last) "{{{1
  call s:ez.hl.preview(a:first, a:last)
endfunction

function! ezbar#get_highlighter() "{{{1
  return s:ez.hl
endfunction

function! ezbar#disable() "{{{1
  silent set statusline&
  for n in range(1, winnr('$'))
    call setwinvar(n, '&statusline', &statusline)
  endfor

  augroup plugin-ezbar
    autocmd!
  augroup END
endfunction "}}}

function! ezbar#enable() "{{{1
  augroup plugin-ezbar
    autocmd!
    autocmd WinEnter,BufWinEnter,FileType,ColorScheme * call ezbar#set()
    autocmd ColorScheme,SessionLoadPost * call ezbar#hl_refresh()
  augroup END
endfunction
"}}}

call s:ez.init()

if expand("%:p") !=# expand("<sfile>:p")
  finish
endif
" echo s:ez.string('active', winnr())
" echo s:ez.string('inactive')

" vim: foldmethod=marker

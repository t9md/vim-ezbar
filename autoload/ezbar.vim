" Utility:
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
  let self.hlmanager = ezbar#hlmanager#new('EzBar')
endfunction

function! s:ez.prepare(win, winnum) "{{{1
  let g:ezbar.parts.__active = ( a:win ==# 'active' )
  let g:ezbar.parts.__is_active = g:ezbar.parts.__active  " compatibly
  let g:ezbar.parts.__parts  = {}
  let g:ezbar.parts.__layout = type(g:ezbar[a:win]) == s:TYPE_STRING
        \ ? split(g:ezbar[a:win])
        \ : copy(g:ezbar[a:win])

  let g:ezbar.parts.__default_color =
        \ ( a:win ==# 'active' ) ? 'StatusLine' : 'StatusLineNC'
  " Init:
  if exists('*g:ezbar.parts._init')
    call g:ezbar.parts._init(a:winnum)
  endif

  " Normalize:
  call map(g:ezbar.parts.__layout,
        \ 'self.normalize_part(a:win, v:val, a:winnum)')

  " Eliminate:
  call filter(g:ezbar.parts.__parts, '!empty(v:val.s)')
  call filter(g:ezbar.parts.__layout, '!empty(v:val)')
  call filter(g:ezbar.parts.__layout, '!empty(v:val.s)')

  if exists('*g:ezbar.parts._finish')
    call g:ezbar.parts._finish()
  endif
  return g:ezbar.parts.__layout
endfunction

function! s:ez.normalize_part(win, part, winnum) "{{{1
  " using call() below is workaround to avoid strange missing ':' after '?' error
  let R = has_key(g:ezbar.parts, a:part)
        \ ? call(g:ezbar.parts[a:part], [a:winnum], g:ezbar.parts)
        \ : g:ezbar.parts._parts_missing(a:winnum, a:part)

  let PART = type(R) isnot s:TYPE_DICTIONARY ? { 's' : R } : R
  let PART.name = a:part

  if empty(get(PART, 'c')) 
    let PART.c = copy(g:ezbar.parts.__default_color)
  endif
  let g:ezbar.parts.__parts[a:part] = PART

  return PART
endfunction

function! s:ez.color_of(win, part) "{{{1
  let color = get(a:part, (a:win ==# 'active' ? 'ac' : 'ic' ), a:part.c)
  return self.hlmanager.register(color)
endfunction

function! s:ez.string(win, winnum) "{{{1
  let self.separator_L = get(g:ezbar, 'separator_L', '|')
  let self.separator_R = get(g:ezbar, 'separator_R', '|')

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

    let next = idx + 1

    if next != layout_len && layout[next].s ==# '%='
      let self.section = 'R'
      let RESULT .= s
      continue
    endif

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
  call s:ez.hlmanager.refresh()
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
    call matchadd(s:ez.hlmanager.register(eval(color)), '\V' . color)
  endfor
endfunction

function! s:extract_airline_color(string) "{{{1
  return matchstr(a:string, '\v\zs[.*\]\ze')
endfunction

function! ezbar#check_highlight2() range "{{{1
  " clear
  call map(
        \ filter(getmatches(), 'v:val.group =~# "EzBar"'),
        \ 'matchdelete((v:val.id)')

  for n in range(a:firstline, a:lastline)
    let color_s = s:extract_airline_color(getline(n))
    if empty(color_s) | continue | endif
    let color = eval(color_s)[0:1]
    let ezbar_expr = " { 'gui': " . string(color) . " }"
    let ezbar_color = eval(ezbar_expr)
    call matchadd(s:ez.hlmanager.register(ezbar_color), '\V' . color_s)
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

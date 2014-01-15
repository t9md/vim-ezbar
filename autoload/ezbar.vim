" Utility:
function! s:extract_color_definition(string) "{{{1
  return matchstr(a:string, '\v\{\s*''(gui|cterm)''\s*:\s*\[.{-}\]\s*}')
endfunction
"}}}

" Main:
let s:TYPE_STRING     = type('')
let s:TYPE_DICTIONARY = type({})
let s:TYPE_NUMBER     = type(0)
let s:LR_SEPARATOR    = '^=\+'
let s:COLOR_SETTER    = '\v^[-=]+\s*\zs\S*'

let s:ez = {}
function! s:ez.init() "{{{1
  let self.hlmanager = ezbar#hlmanager#new('EzBar')
  let self.color     = {
        \ 'StatusLine':   self.hlmanager.convert('StatusLine'),
        \ 'StatusLineNC': self.hlmanager.convert('StatusLineNC'),
        \ }
endfunction

function! s:ez.prepare(win, winnum) "{{{1
  let [EB, PARTS]    = [ g:ezbar, g:ezbar.parts ]
  let active         = a:win ==# 'active'
  let PARTS          = EB.parts
  let PARTS.__active = active
  let PARTS.__parts  = {}
  let PARTS.__layout = copy(EB[a:win])
  let PARTS.__color  = self.color[ active ? 'StatusLine' : 'StatusLineNC']
  let PARTS.__       = ezbar#util#get()

  " Init:
  if exists('*PARTS._init') | call PARTS._init(a:winnum) | endif
  " Normalize:
  call map(PARTS.__layout, 'self.part_normalize(a:win, v:val, a:winnum)')
  " Eliminate:
  call filter(PARTS.__parts,  '!empty(v:val.s)')
  call filter(PARTS.__layout, '!empty(v:val.s)')

  if exists('*PARTS._finish')
    call PARTS._finish()
  endif
  return PARTS.__layout
endfunction

function! s:ez.part_normalize(win, part, winnum) "{{{1
  let [EB, PARTS] = [ g:ezbar, g:ezbar.parts ]
  try
    " using call() below is workaround to avoid strange missing ':' after '?' error
    let R =
          \ has_key(PARTS, a:part) ? call(PARTS[a:part], [a:winnum], PARTS) :
          \ a:part =~# '^[-=]' ? self.color_or_separator(a:part) :
          \ PARTS._parts_missing(a:winnum, a:part)
  catch
    if !exists(R)
      let R = printf('ERR: in %s', a:part)
    endif
  endtry

  let part = type(R) isnot s:TYPE_DICTIONARY ? { 's' : R } : R
  let part.name = a:part

  if empty(get(part, 'c'))
    let part.c = copy(PARTS.__color)
  endif
  let PARTS.__parts[a:part] = part

  return part
endfunction

function! s:ez.color_or_separator(part) "{{{1
  let [EB, PARTS] = [ g:ezbar, g:ezbar.parts ]
  let color = matchstr(a:part, s:COLOR_SETTER)
  if !empty(color)
    let PARTS.__color = EB.color[color]
  endif
  let R = { 's': (a:part =~# s:LR_SEPARATOR ) ? '%=' : '' }
  return R
endfunction

function! s:ez.color_of(win, part) "{{{1
  let color = get(a:part, (a:win ==# 'active' ? 'ac' : 'ic' ), a:part.c)
  return self.hlmanager.register(color)
endfunction

function! s:ez.string(win, winnum) "{{{1
  let self.separator_L = get(g:ezbar, 'separator_L', '|')
  let self.separator_R = get(g:ezbar, 'separator_R', '|')

  let RESULT       = ''
  let self.section = 'L'
  let layout       = self.prepare(a:win, a:winnum)
  let layout_len   = len(layout)
  let last_idx = layout_len - 1

  for idx in range(layout_len)
    unlet! part
    let part    = layout[idx]
    let color   = self.color_of(a:win, part)
    let color_s = '%#' . color . '#'
    let s = printf('%%#%s# %s ', color, part.s)

    if idx ==# last_idx
      let RESULT .= s | continue
    endif

    let next = idx + 1
    if layout[next].s ==# '%='
      let self.section = 'R'
      let RESULT .= s
      continue
    endif
    if color ==# self.color_of(a:win, layout[next])
      let s .= self['separator_' . self.section]
    endif
    let RESULT .= s
  endfor
  return RESULT
endfunction
"}}}

" Public:
function! ezbar#string(win, winnum) "{{{1
  let s = ''
  try
    let s = s:ez.string(a:win, a:winnum)
  catch
    echom v:exception
  finally
    return s
  endtry
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

function! ezbar#hlmanager() "{{{1
  return s:ez.hlmanager
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

function! ezbar#color_check() range "{{{1
  " clear color
  call map(
        \ filter(getmatches(), 'v:val.group =~# "EzBar"'),
        \ 'matchdelete(v:val.id)')

  for n in range(a:firstline, a:lastline)
    let color = s:extract_color_definition(getline(n))
    if empty(color) | continue | endif
    call matchadd(s:ez.hlmanager.register(eval(color)), '\V' . color)
  endfor
endfunction

function! ezbar#color_capture(color) "{{{1
  let R = s:ez.hlmanager.convert_full(a:color)
  call setreg(v:register, string(R), 'V')
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

" vim: foldmethod=marker

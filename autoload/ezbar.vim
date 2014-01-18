" Utility:
function! s:extract_color_definition(string) "{{{1
  return matchstr(a:string, '\v\{\s*''(gui|cterm)''\s*:\s*\[.{-}\]\s*}')
endfunction
"}}}

" Main:
let s:TYPE_STRING     = type('')
let s:TYPE_LIST       = type([])
let s:TYPE_DICTIONARY = type({})
let s:TYPE_NUMBER     = type(0)
let s:SCREEN          = has('gui_running') ? 'gui' : 'cterm'
let s:LR_SEPARATOR    = '^=\+'
let s:COLOR_SETTER    = '\v^(-+|\=+|\|)\s*\zs\w*$'

let s:ez = {}
function! s:ez.init() "{{{1
  let s:HELPER = ezbar#helper#get()
  let self.hlmanager = ezbar#hlmanager#new('EzBar')
  let self.color     = {
        \ 'StatusLine':   self.hlmanager.convert('StatusLine'),
        \ 'StatusLineNC': self.hlmanager.convert('StatusLineNC'),
        \ }
endfunction

function! s:ez.prepare() "{{{1
  " Init:
  let layout_save = s:PARTS.__layout
  if exists('*s:PARTS.__init')
    call s:PARTS.__init()
  endif
  if layout_save isnot s:PARTS.__layout
    let s:PARTS.__layout = copy(s:PARTS.__layout)
  endif

  let self._section_color = {}
  " Normalize:
  call map(s:PARTS.__layout, 'self.normalize(v:val)')

  " Eliminate:
  call filter(s:PARTS.__parts,  '!(v:val.s is "")')
  call filter(s:PARTS.__layout, '!(v:val.s is "")')

  " Finalize:
  if exists('*s:PARTS.__finish')
    call s:PARTS.__finish()
  endif
  return self
endfunction

function! s:ez.normalize(part) "{{{1
  try
    " using call() below is workaround to avoid strange missing ':' after '?' error
    let section_color = copy(s:PARTS.__c)
    let R =
          \ has_key(s:PARTS, a:part) ?
          \ call(s:PARTS[a:part], [], s:PARTS) :
          \ a:part =~# '^[-=|]' ?
          \ self.color_or_separator(a:part) :
          \ s:PARTS.__part_missing(a:part)
  catch
    let s = substitute(a:part, '\v^([-=])+\s*(.*)', '\1 \2','')
    let R = { 's': printf('[%s]', s), 'c': 'WarningMsg' }
  endtry

  let part = type(R) isnot s:TYPE_DICTIONARY ? { 's' : R } : R
  let part.name = a:part

  if empty(get(part, 'c'))
    " won't deepcopy for performance for ordinary user.
    let part.c = copy(s:PARTS.__c)
  endif
  " keep section color info
  let part.__section_color = section_color

  let s:PARTS.__parts[a:part] = part
  return part
endfunction

function! s:ez.color_or_separator(part) "{{{1
  let color = matchstr(a:part, s:COLOR_SETTER)
  if !empty(color)
    let s:PARTS.__c = s:COLOR[color]
  endif
  return { 's': (a:part =~# s:LR_SEPARATOR ) ? '%=' : '' }
endfunction

function! s:ez.color_of(part) "{{{1
  return get(a:part,
        \ ( s:PARTS.__active ? 'ac' : 'ic' ), a:part.c)
endfunction

function! s:ez.color_info(color) "{{{1
  let R = {
        \ 'name':self.hlmanager.register(a:color),
        \ 'bg': a:color[s:SCREEN][0],
        \ 'fg': a:color[s:SCREEN][1],
        \ }
  return R
endfunction

function! s:ez.specialvar_setup(active, winnr) "{{{1
  let s:PARTS.__active   = a:active
  let s:PARTS.__mode     = mode()
  let s:PARTS.__winnr    = a:winnr
  let s:PARTS.__bufnr    = winbufnr(a:winnr)
  let s:PARTS.__width    = winwidth(a:winnr)
  let s:PARTS.__filetype = getwinvar(a:winnr, '&filetype')
  let s:PARTS.__buftype  = getwinvar(a:winnr, '&buftype')
  let s:PARTS.__parts    = {}
  let s:PARTS.__layout   = copy(s:EB[ a:active ? 'active' : 'inactive'])
  let s:PARTS.__color    = s:COLOR
  let s:PARTS.__c        = self.color[ a:active ? 'StatusLine' : 'StatusLineNC']
  let s:PARTS.__         = s:HELPER
endfunction

function! s:ez.theme_load() "{{{1
  if !get(s:EB, '__theme_loaded')
    call extend(s:COLOR, ezbar#themes#{s:EB.theme}#load())
    let s:EB.__theme_loaded = 1
  endif
endfunction
"}}}

let s:mode2color = {
      \ 'n':      'm_normal',
      \ 'i':      'm_insert',
      \ 'R':      'm_replace',
      \ 'v':      'm_visual',
      \ 'V':      'm_visual',
      \ "\<C-v>": 'm_visual',
      \ 'c':      'm_other',
      \ 's':      'm_other',
      \ 'S':      'm_other',
      \ "\<C-s>": 'm_other',
      \ '?':      'm_other',
      \ }

function! s:ez.color_setup() "{{{1
  let color      = get(s:mode2color, s:PARTS.__mode, 'm_normal')
  let color1     = s:COLOR[color]
  let color1_rev = s:HELPER.reverse(color1)
  let color2     = s:HELPER.bg(color1_rev, s:COLOR['_2'])
  let s:COLOR.1  = color1
  let s:COLOR.2  = color2
  let s:COLOR.3  = color1_rev
endfunction

function! s:ez.string(active, winnr) "{{{1
  call self.theme_load()
  call self.specialvar_setup(a:active, a:winnr)
  if s:PARTS.__active
    call self.color_setup()
  endif
  return self.prepare().insert_separator().join()
endfunction

function! s:ez.join() "{{{1
  return join(map(s:PARTS.__layout, "printf('%%#%s#%s', v:val.color_name, v:val.s)"), '')
endfunction

function! s:ez.insert_separator() "{{{1
  let sep_L        = get(g:ezbar, 'separator_L', '|')
  let sep_R        = get(g:ezbar, 'separator_R', '|')
  let sep_border_L = get(g:ezbar, 'separator_border_L', '')
  let sep_border_R = get(g:ezbar, 'separator_border_R', '')

  let LAYOUT    = s:PARTS.__layout
  let idx_last  = len(LAYOUT) - 1
  let idx_LRsep = self.LR_separator_index(LAYOUT)
  let section   = 'L'

  let R = []
  for [idx, part] in map(copy(LAYOUT), '[v:key, v:val]')
    let idx_next        = idx + 1
    let color           = self.color_info(self.color_of(part))
    let part.color_name = color.name
    if idx is idx_LRsep
      let section = 'R'
    else
      let part.s = ' ' . part.s . ' '
    endif
    call add(R, part)

    if idx is idx_last       | break    | endif
    if idx_next is idx_LRsep | continue | endif

    let part_next  = LAYOUT[idx_next]
    let color_next = self.color_info(self.color_of(part_next))

    if color.bg is color_next.bg
      let s = sep_{section}
      let c = self.color_info(part.__section_color)
    else
      let s = sep_border_{section}
      let _c = {}
      let _c[s:SCREEN] = section is 'L'
            \ ? [ color_next.bg, color.bg      ]
            \ : [ color.bg,      color_next.bg ]
      let c = self.color_info(_c)
    endif
    call add(R, { 's' : s, 'color_name': c.name })
  endfor
  let s:PARTS.__layout = R
  return self
endfunction

function! s:ez.LR_separator_index(layout)
  for [idx, s] in map(copy(a:layout), '[v:key, v:val.s]')
    if s is '%=' | return idx | endif
  endfor
endfunction

function! s:ez.is_LR_separator(part)
  return a:part.s is '%='
endfunction
"}}}

" Public:
function! ezbar#string(active, winnr) "{{{1
  let s:EB     = g:ezbar
  let s:PARTS  = s:EB.parts
  call s:HELPER.__init()
  if type(get(s:EB, 'color')) isnot s:TYPE_DICTIONARY
    let s:EB.color = {}
  endif
  let s:COLOR = s:EB.color
  try
    let s = ''
    let s = s:ez.string(a:active, a:winnr)
  catch
    echom v:exception
  finally
    return s
  endtry
endfunction

function! ezbar#nop(...) "{{{1
endfunction

function! ezbar#set() "{{{1
  let winnr_active = winnr()
  " setup each window's &statusline to
  "   %!ezbar#string(num is winnr_active, winnr())
  call map(range(1, winnr('$')), '
        \ setwinvar(v:val, "&statusline",
        \ "%!ezbar#string(". (v:val is# winnr_active) . ", " . v:val . ")")
        \ ')
endfunction

function! ezbar#hl_refresh() "{{{1
  let s:EB.__theme_loaded = 0
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
"}}}

call s:ez.init()

if expand("%:p") !=# expand("<sfile>:p")
  finish
endif

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
" vim: foldmethod=marker

" Constants:
let s:TYPE_STRING     = type('')
let s:TYPE_LIST       = type([])
let s:TYPE_DICTIONARY = type({})
let s:TYPE_NUMBER     = type(0)
let s:SCREEN          = has('gui_running') ? 'gui' : 'cterm'
let s:LR_SEPARATOR    = '\v\=+\s*(\w*)'
let s:COLOR_SETTER    = '\v^%(-+|\|)\s*(\w*)$'
let s:MODE2COLOR      = {
      \ 'n':      'm_normal',
      \ 'i':      'm_insert',
      \ 'R':      'm_replace',
      \ 'v':      'm_visual',
      \ 'V':      'm_visual',
      \ "\<C-v>": 'm_visual',
      \ 'c':      'm_command',
      \ 's':      'm_select',
      \ 'S':      'm_select',
      \ "\<C-s>": 'm_select',
      \ '?':      'm_other',
      \ }

" Utility:
function! s:extract_color_definition(string) "{{{1
  return matchstr(a:string, '\v\{\s*''(gui|cterm)''\s*:\s*\[.{-}\]\s*}')
endfunction
"}}}

" SpecialParts:
let s:speacial_parts = {}
function! s:speacial_parts.___setcolor(color) "{{{1
  let self.__c = s:COLOR[a:color]
  return ''
endfunction

function! s:speacial_parts.___LR_separator(...) "{{{1
  let color = get(a:000, 0, '')
  if color isnot ''
    call self.___setcolor(color)
  endif
  return { 's': '%=' }
endfunction
"}}}

" Main:
let s:ez = {}
function! s:ez.init() "{{{1
  let s:HELPER = ezbar#helper#get()
  let self.hlmanager = ezbar#hlmanager#new('EzBar')
  let self._color_cache = {}
  let self.color     = {
        \ 'StatusLine':   self.hlmanager.convert('StatusLine'),
        \ 'StatusLineNC': self.hlmanager.convert('StatusLineNC'),
        \ }
endfunction

function! s:ez.unalias() "{{{1
  if has_key(s:EB, 'alias')
    call map(s:PARTS.__layout, 'get(s:EB.alias, v:val, v:val)')
  endif
endfunction

function! s:ez.substitute(part) "{{{1
  let R = substitute(a:part,
        \ s:LR_SEPARATOR, '\= "___LR_separator::" . submatch(1)', '')
  return substitute(R,
        \ s:COLOR_SETTER, '\= "___setcolor::" . submatch(1)', '')
endfunction

function! s:ez.prepare() "{{{1
  " Init:
  call self.unalias()
  if exists('*s:PARTS.__init')
    let layout_save = s:PARTS.__layout
    call s:PARTS.__init()
    if layout_save isnot s:PARTS.__layout
      let s:PARTS.__layout  = type(s:PARTS.__layout) isnot s:TYPE_LIST
            \ ? split(s:PARTS.__layout) : copy(s:PARTS.__layout)
      call self.unalias()
    endif
  endif

  call extend(s:PARTS, s:speacial_parts, 'force')
  call map(s:PARTS.__layout,    'self.substitute(v:val)')
  call map(s:PARTS.__layout,    'self.normalize(v:val)')
  call filter(s:PARTS.__parts,  '!(v:val.s is "")')
  call filter(s:PARTS.__layout, '!(v:val.s is "")')

  " Finalize:
  if exists('*s:PARTS.__finish') | call s:PARTS.__finish() | endif
  return self
endfunction

function! s:ez.transform(part) "{{{1
  let [part; args] = split(a:part, '::')
  if has_key(s:PARTS, part)
    return call(s:PARTS[part], args, s:PARTS)
  elseif has_key(s:PARTS, '__part_missing')
    return call(s:PARTS.__part_missing, [part] + args, s:PARTS)
  endif
  return ''
endfunction

function! s:ez.normalize(part) "{{{1
  try
    " using call() below is workaround to avoid strange missing ':' after '?' error
    let R = self.transform(a:part)
  catch
    let R = { 's': printf('[%s]', a:part), 'c': 'WarningMsg' }
  endtry

  let part = type(R) isnot s:TYPE_DICTIONARY ? { 's' : R } : R
  let part.name = a:part

  let key = s:PARTS.__active ? 'ac' : 'ic'
  let part.c =
        \ has_key(part, key) ? part[key] :
        \ has_key(part, 'c') ? part.c    :
        \ copy(s:PARTS.__c)

  " keep section color info
  let part.__section_color = copy(s:PARTS.__c)

  let s:PARTS.__parts[a:part] = part
  return part
endfunction

function! s:ez.color_of(part) "{{{1
  let R = a:part.c
  if type(R) is s:TYPE_DICTIONARY
    return R
  endif

  if !has_key(self._color_cache, R)
    let self._color_cache[R] = self.hlmanager.convert(R)
  endif
  return self._color_cache[R]
endfunction

function! s:ez.color_info(color) "{{{1
  return {
        \ 'name':self.hlmanager.register(a:color),
        \ 'bg': a:color[s:SCREEN][0],
        \ 'fg': a:color[s:SCREEN][1],
        \ }
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
  let layout             = s:EB[ a:active ? 'active' : 'inactive']
  let s:PARTS.__layout   = type(layout) isnot s:TYPE_LIST
        \ ? split(layout) : copy(layout)
  let s:PARTS.__color    = s:COLOR
  let s:PARTS.__c        = self.color[ a:active ? 'StatusLine' : 'StatusLineNC']
  let s:PARTS.__         = s:HELPER
endfunction

    " for [k, v] in items(s:COLOR)
      " if type(v) is s:TYPE_STRING
        " let s:COLOR[k] = self.hlmanager.convert(v)
      " endif
      " unlet v
    " endfor

function! s:ez.theme_load() "{{{1
  if !get(s:EB, '__theme_loaded')
    call extend(s:COLOR, ezbar#themes#{s:EB.theme}#load())
    let self._color_cache = {}
    let s:EB.__theme_loaded = 1
  endif
endfunction

function! s:ez.color_setup() "{{{1
  let color      = get(s:MODE2COLOR, s:PARTS.__mode, 'm_normal')
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
  for [idx, idx_next, part] in map(copy(LAYOUT), '[v:key, v:key+1, v:val]')
    let color           = self.color_info(self.color_of(part))
    let part.color_name = color.name

    if idx isnot idx_LRsep | let part.s = ' ' . part.s . ' ' | endif
    call add(R, part)

    if idx is idx_last | break | endif
    if idx_next is idx_LRsep
      let section = 'R'
      continue
    endif

    let color_next = self.color_info(self.color_of(LAYOUT[idx_next]))
    let [ s, c ] = color.bg is color_next.bg
          \ ? [ sep_{section}       , part.__section_color ]
          \ : [ sep_border_{section}, { s:SCREEN : section is 'L' ?
          \ [color_next.bg, color.bg] : [color.bg, color_next.bg]
          \ } ]
    call add(R, { 's' : s, 'color_name': self.color_info(c).name })
  endfor
  let s:PARTS.__layout = R
  return self
endfunction

function! s:ez.LR_separator_index(layout) "{{{1
  for [idx, s] in map(copy(a:layout), '[v:key, v:val.s]')
    if s is '%=' | return idx | endif
  endfor
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

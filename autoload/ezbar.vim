" Overview:
" g:ezbar.layout
" # Design & terminology
"  ezbar compose &statusline string from layout(array of part)
"   * layout: Array of part
"   * part: Each part must have corresponding part function.
"           Part will be transformed to result of corresponding part func.
"   * part_def: Dictionary representation for part.
"   * part_func: return part_def or string.
"   * helper: helper functions avaiable within part function.
"   * theme: color theme.
"
" # Processsing flow
"  preparation
"    - unalias if aliased.
"    - extend parts with special_parts
"    - substitute_part
"        substitute ===, ---, | to corresponding parts name.
"  transform
"     evaluate each parts.
"     in this stage, layout is transformed to array of part_def.
"  insert_separator
"     insert separator between each parts.
"  join()
"     join layout to string.
"

" Util:
let s:_ = ezbar#util#get()
let s:SCREEN = s:_.screen_type()

let s:MODE2COLOR   = {
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

" Special Parts:
let s:speacial_parts = {}
function! s:speacial_parts.___setcolor(color) "{{{1
  let color = a:color =~# '^\d$'
        \ ? get(s:MODE2COLOR, s:Parts.__mode, 'm_normal') . '_' . a:color
        \ : a:color

  let self.__c = g:ezbar.color[color]
  return ''
endfunction

function! s:speacial_parts.___separator(...) "{{{1
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
  let s:Helper          = ezbar#helper#get()
  let self.hlmanager    = ezbar#hlmanager#new('EzBar')
  let self._color_cache = {}
  let self.color     = {
        \ 'StatusLine':   self.hlmanager.convert('StatusLine'),
        \ 'StatusLineNC': self.hlmanager.convert('StatusLineNC'),
        \ }
endfunction

function! s:ez.unalias() "{{{1
  if !has_key(self.conf, 'alias')
    return
  endif
  call map(s:Parts.__layout, 'get(self.conf.alias, v:val, v:val)')
endfunction

function! s:ez.substitute_part(part) "{{{1
  " '====='
  let separator = '\v\=+\s*(\w*)'
  let R = substitute(a:part,
        \ separator, '\= "___separator::" . submatch(1)', '')

  " '----' or '|'
  let color_changer = '\v^%(-+|\|)\s*(\w*)$'
  return substitute(R,
        \ color_changer, '\= "___setcolor::" . submatch(1)', '')
endfunction
"}}}

function! s:ez.normalize_layout(layout) "{{{1
  return s:_.is_List(a:layout) ? copy(a:layout) : split(a:layout)
endfunction

function! s:ez.prepare() "{{{1
  call self.unalias()

  if exists('*s:Parts.__init')
    let layout_save = s:Parts.__layout
    call s:Parts.__init()
    if layout_save isnot s:Parts.__layout
      let s:Parts.__layout = self.normalize_layout(s:Parts.__layout)
      call self.unalias()
    endif
  endif

  if !has_key(s:Parts, '__loaded_special_parts')
    call extend(s:Parts, s:speacial_parts)
    let s:Parts.__loaded_special_parts = 1
  endif

  call map(s:Parts.__layout, 'self.substitute_part(v:val)')
  call map(s:Parts.__layout, 'self.normalize_part(v:val)')
  call filter(s:Parts.__layout, '!(v:val.s is "")')
  call filter(s:Parts.__parts,  '!(v:val.s is "")')
  if exists('*s:Parts.__finish') | call s:Parts.__finish() | endif
  return self
endfunction

function! s:ez.transform_part(part) "{{{1
  let [part; args] = split(a:part, '::')
  return has_key(s:Parts, part)
        \ ? call(s:Parts[part], args, s:Parts)
        \ : has_key(s:Parts, '__part_missing')
        \ ? call(s:Parts.__part_missing, [part] + args, s:Parts)
        \ : ''
endfunction

function! s:ez.normalize_part(part) "{{{1
  " Normalize: make transformed result into dictionary and add necessary
  " attributes.
  try
    let R = self.transform_part(a:part)
  catch
    let R = { 's': printf('[%s]', a:part), 'c': 'WarningMsg' }
  endtry

  let part = s:_.is_Dictionary(R) ? R : { 's' : R }
  let part.name = a:part

  let key = s:Parts.__active ? 'ac' : 'ic'
  let part.c =
        \ has_key(part, key) ? part[key] :
        \ has_key(part, 'c') ? part.c    :
        \ copy(s:Parts.__c)

  " keep section color info
  let part.__section_color = copy(s:Parts.__c)
  let s:Parts.__parts[a:part] = part
  return part
endfunction

function! s:ez.color_of(part) "{{{1
  let R = a:part.c
  if s:_.is_Dictionary(R)
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

function! s:ez.setup(active, winnr) "{{{1
  if !self.conf.__loaded_theme
    call self.load_theme(self.conf.theme)
  endif

  call extend(s:Parts, {
        \ '__active':   a:active,
        \ '__mode':     mode(),
        \ '__winnr':    a:winnr,
        \ '__bufnr':    winbufnr(a:winnr),
        \ '__width':    winwidth(a:winnr),
        \ '__filetype': getwinvar(a:winnr, '&filetype'),
        \ '__buftype':  getwinvar(a:winnr, '&buftype'),
        \ '__parts':    {},
        \ '__color':    g:ezbar.color,
        \ '__layout':   self.normalize_layout(self.conf[ a:active ? 'active' : 'inactive' ]),
        \ '__c':        self.color[a:active ? 'StatusLine' : 'StatusLineNC'],
        \ '__':         s:Helper,
        \ })

  if self._did_setup
    return
  endif

  " for performance benefit, we setup once per refresh.
  call extend(self, {
        \ 'sep_L':        get(g:ezbar, 'separator_L', '|'),
        \ 'sep_R':        get(g:ezbar, 'separator_R', '|'),
        \ 'sep_border_L': get(g:ezbar, 'separator_border_L', ''),
        \ 'sep_border_R': get(g:ezbar, 'separator_border_R', ''),
        \ })
  let self._did_setup = 1
endfunction

function! s:ez.load_theme(theme) "{{{1
  let self._color_cache = {}
  let theme = ezbar#theme#load(a:theme)
  call extend(g:ezbar.color, theme)
  let self.conf.__loaded_theme = 1
endfunction

function! s:ez.join() "{{{1
  return join(map(s:Parts.__layout, "printf('%%#%s#%s', v:val.color_name, v:val.s)"), '')
endfunction

let s:conf_default = {
      \ '__loaded_default_config': 0,
      \ '__loaded_theme': 0,
      \ 'theme': 'default',
      \ 'hide_rule': {},
      \ 'color': {},
      \ }

function! s:ez.string(active, winnr) "{{{1
  let self.conf = g:ezbar
  cal extend(self.conf, s:conf_default, 'keep')
  if g:ezbar_enable_default_config && !self.conf.__loaded_default_config
    call extend(self.conf, ezbar#config#default#get(), 'keep')
    let self.conf.__loaded_default_config = 1
  endif
  let s:Parts  = self.conf.parts
  try
    call self.setup(a:active, a:winnr)
    let s = ''
    let s = self.prepare().insert_separator().join()
  catch
    echom v:exception
  finally
    return s
  endtry
endfunction

function! s:ez.insert_separator() "{{{1
  let LAYOUT    = s:Parts.__layout
  let idx_last  = len(LAYOUT) - 1
  let idx_LRsep = self.index_of_LR_separator(LAYOUT)
  let section   = 'L'

  let R = []
  for [idx, idx_next, part] in map(copy(LAYOUT), '[v:key, v:key+1, v:val]')
    let color           = self.color_info(self.color_of(part))
    let part.color_name = color.name

    if idx isnot idx_LRsep | let part.s = ' ' . part.s . ' ' | endif
    call add(R, part)

    if idx is idx_last | break | endif

    let color_next = self.color_info(self.color_of(LAYOUT[idx_next]))
    if color.bg is color_next.bg && idx_next is idx_LRsep
      let section = 'R'
      continue
    endif

    let [ s, c ] = color.bg is color_next.bg
          \ ? [ self['sep_' . section]       , part.__section_color ]
          \ : [ self['sep_border_' . section], { s:SCREEN : section is 'L' ?
          \ [color_next.bg, color.bg] : [color.bg, color_next.bg]
          \ } ]
    call add(R, { 's' : s, 'color_name': self.color_info(c).name })
    if idx_next is idx_LRsep
      let section = 'R'
    endif
  endfor
  let s:Parts.__layout = R
  return self
endfunction

function! s:ez.index_of_LR_separator(layout) "{{{1
  for [idx, s] in map(copy(a:layout), '[v:key, v:val.s]')
    if s ==# '%='
      return idx
    endif
  endfor
  return -1
endfunction
"}}}

" API:
function! ezbar#string(active, winnr) "{{{1
  return s:ez.string(a:active, a:winnr)
endfunction

function! ezbar#set() "{{{1
  let active = winnr()
  " setup each window's &statusline to
  "   %!ezbar#string(active, winnr())
  let s:ez._did_setup = 0
  call map(range(1, winnr('$')), '
        \ setwinvar(v:val, "&statusline",
        \ printf("%%!ezbar#string(%d, %d)", v:val is# active, v:val))
        \ ')
endfunction

function! ezbar#hl_refresh() "{{{1
  let g:ezbar.__loaded_theme = 0
  call s:ez.hlmanager.refresh()
endfunction

function! ezbar#hlmanager() "{{{1
  return s:ez.hlmanager
endfunction

function! ezbar#enable() "{{{1
  augroup plugin-ezbar
    autocmd!
    autocmd WinEnter,BufWinEnter,FileType,ColorScheme * call ezbar#set()
    autocmd ColorScheme,SessionLoadPost * call ezbar#hl_refresh()
  augroup END
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

function! ezbar#load_theme(theme) "{{{1
  call s:ez.load_theme(a:theme)
endfunction
"}}}

call s:ez.init()
" vim: foldmethod=marker

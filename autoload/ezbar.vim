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

function! s:index_of_LR_separator(layout) "{{{1
  for [idx, s] in map(copy(a:layout), '[v:key, v:val.s]')
    if s ==# '%='
      return idx
    endif
  endfor
  return -1
endfunction
"}}}

" Table map from mode() string to color name in theme.
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
" Special Parts is special parts which is always merged into g:ezbar.parts.
let s:speacial_parts = {}

function! s:speacial_parts.___setcolor(color) "{{{1
  " __setcolor(color) set default section color( part.__c ).
  let color = a:color =~# '^\d$'
        \ ? get(s:MODE2COLOR, s:Parts.__mode, 'm_normal') . '_' . a:color
        \ : a:color

  let self.__c = g:ezbar.color[color]
  return ''
endfunction

function! s:speacial_parts.___separator(...) "{{{1
  " Return separator representation('%=').
  let color = get(a:000, 0, '')
  if color isnot ''
    call self.___setcolor(color)
  endif
  return { 's': '%=' }
endfunction
"}}}

" ColorCache:
let s:cc = {}

function! s:cc.new(mgr) "{{{1
  let self.data = {}
  let self.mgr = a:mgr
  return self
endfunction

function! s:cc.reset() "{{{1
  let self.data = {}
endfunction

function! s:cc.get(part) "{{{1
  let _color = a:part.c
  if s:_.is_Dictionary(_color)
    return self.info(_color)
  endif

  " Cache for performance.
  if !has_key(self.data, _color)
    let color = self.mgr.convert(_color)
    let self.data[color]
  endif

  return self.info(color)
endfunction

function! s:cc.info(color) "{{{1
  return {
        \ 'name': self.mgr.register(a:color),
        \ 'bg': a:color[s:SCREEN][0],
        \ 'fg': a:color[s:SCREEN][1],
        \ }
endfunction
"}}}

" Main:
let s:ez = {}

function! s:ez.init() "{{{1
  let s:Helper          = ezbar#helper#get()
  let self.hlmanager    = ezbar#hlmanager#new('EzBar')
  let self.cc = s:cc.new(self.hlmanager)
  let self.color     = {
        \ 'StatusLine':   self.hlmanager.convert('StatusLine'),
        \ 'StatusLineNC': self.hlmanager.convert('StatusLineNC'),
        \ }
endfunction
"}}}

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
  if !has_key(s:Parts, '__loaded_special_parts')
    call extend(s:Parts, s:speacial_parts)
    let s:Parts.__loaded_special_parts = 1
  endif

  try
    call self.setup(a:active, a:winnr)
    let s = ''
    call self.prepare()
    call self.insert_separator()
    let s = self.join()
  catch
    echom v:exception
  finally
    return s
  endtry
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
        \ '__layout':   self.layout_normalize(self.conf[ a:active ? 'active' : 'inactive' ]),
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

function! s:ez.prepare() "{{{1
  call self.unalias()
  if exists('*s:Parts.__init')
    let layout_save = s:Parts.__layout
    call s:Parts.__init()
    if layout_save isnot s:Parts.__layout
      let s:Parts.__layout = self.layout_normalize(s:Parts.__layout)
      call self.unalias()
    endif
  endif

  call map(s:Parts.__layout, 'self.part_substitute(v:val)')
  call map(s:Parts.__layout, 'self.part_transform(v:val)')
  call filter(s:Parts.__layout, '!(v:val.s is "")')
  call filter(s:Parts.__parts,  '!(v:val.s is "")')
  if exists('*s:Parts.__finish')
    call s:Parts.__finish()
  endif
endfunction

function! s:ez.unalias() "{{{1
  if !has_key(self.conf, 'alias')
    return
  endif
  call map(s:Parts.__layout, 'get(self.conf.alias, v:val, v:val)')
endfunction

function! s:ez.part_substitute(part) "{{{1
  " Replace '===='
  " ex)
  "  '===== 1'    -> __separator::1
  "  '=====inact' -> __separator::inact
  "  '====='      -> __separator

  let separator = '\v\=+\s*(\w*)'
  let R = substitute(a:part,
        \ separator, '\= "___separator::" . submatch(1)', '')

  " Replace '----' or '|'
  " ex)
  "  '|1'         -> __setcolor::1
  "  '| 2'        -> __setcolor::2
  "  '----- 1'    -> __setcolor::1
  "  '-----inact' -> __sepcolor::inact
  let color_changer = '\v^%(-+|\|)\s*(\w*)$'
  return substitute(R,
        \ color_changer, '\= "___setcolor::" . submatch(1)', '')
endfunction

function! s:ez.part_transform(part) "{{{1
  " Transform each part and add necessary attributes.
  " 
  " * Part representation
  "  { 's': {string}, 'ic': {color_inactive}, 'ac': {color_active}, 'c': 'color' }`
  "
  "  - Color( either of ac, ic, c ) specifier is optional.
  "  - Color precedence
  "    | No. | color       |  Description             |
  "    | --- | ----------- | ------------------------ |
  "    |  1  | ic, ac      |  Color specified in part |
  "    |  2  | c           |  Color specified in part |
  "    |  3  | s:Parts.__c |  Section color           |
  try
    let [_part; args] = split(a:part, '::')
    let R = has_key(s:Parts, _part)
          \ ? call(s:Parts[_part], args, s:Parts)
          \ : has_key(s:Parts, '__part_missing')
          \ ? call(s:Parts.__part_missing, [_part] + args, s:Parts)
          \ : ''
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

function! s:ez.join() "{{{1
  "  join('[
  "    '%#EzBar00025# •tryit.vim ',
  "    '%#EzBar00006#⮀',
  "  ], '')
  return join(map(s:Parts.__layout, "printf('%%#%s#%s', v:val.color_name, v:val.s)"), '')
endfunction
"}}}

" Misc:
function! s:ez.layout_normalize(layout) "{{{1
  return s:_.is_List(a:layout) ? copy(a:layout) : split(a:layout)
endfunction

function! s:ez.load_theme(theme) "{{{1
  call self.cc.reset()
  let theme = ezbar#theme#load(a:theme)
  call extend(g:ezbar.color, theme)
  let self.conf.__loaded_theme = 1
endfunction

function! s:ez.insert_separator() "{{{1
  " Insert section separator between parts.
  " Consider background change like if
  "  - background color is same to next section, then
  "     -> use g:ezbar.separator_{section}.
  "  - background color is different to next section, then
  "     -> use g:ezbar.separator_border_{section}.
  let LAYOUT    = s:Parts.__layout
  let idx_last  = len(LAYOUT) - 1
  let idx_LRsep = s:index_of_LR_separator(LAYOUT)
  let section   = 'L'

  let R = []
  for [idx, idx_next, part] in map(copy(LAYOUT), '[v:key, v:key+1, v:val]')
    let color           = self.cc.get(part)
    let part.color_name = color.name

    if idx isnot idx_LRsep
      let part.s = ' ' . part.s . ' '
    endif
    call add(R, part)

    if idx is idx_last | break | endif

    let color_next = self.cc.get(LAYOUT[idx_next])
    if color.bg is color_next.bg && idx_next is idx_LRsep
      let section = 'R'
      continue
    endif

    let [ s, c ] = color.bg is color_next.bg
          \ ? [ self['sep_' . section]       , part.__section_color ]
          \ : [ self['sep_border_' . section], { s:SCREEN : section is 'L' ?
          \ [color_next.bg, color.bg] : [color.bg, color_next.bg]
          \ } ]
    call add(R, { 's' : s, 'color_name': self.cc.info(c).name })
    if idx_next is idx_LRsep
      let section = 'R'
    endif
  endfor
  let s:Parts.__layout = R
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

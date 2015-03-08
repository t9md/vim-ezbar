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

function! s:extract_color_definition(string) "{{{1
  return matchstr(a:string, '\v\{\s*''(gui|cterm)''\s*:\s*\[.{-}\]\s*}')
endfunction

function! s:hl_color_names() "{{{1
  let RGB = s:color_name2rgb()
  for [name, _rgb] in items(RGB)
    let rgb = '#' . _rgb
    let color = { s:SCREEN : [rgb, '#000000'] }
    let cname = s:ez.hlmanager.register(color)
    call matchadd(cname, '\<' .name .'\>')
    call matchadd(cname, '\V' . rgb)
  endfor
endfunction

function! s:color_name2rgb() "{{{1
  let lines = readfile(expand("$VIMRUNTIME/rgb.txt"))
  call filter(lines, "v:val !~# '^\s*\d'")
  call filter(lines, 'len(split(v:val)) is# 4')
  let R = {}
  for line in lines
    let [r, g, b, name] = split(line)
    let rgb = printf("%02x%02x%02x", r, g, b)
    let R[name] = rgb
  endfor
  return R
endfunction

function! s:color_names() "{{{1
  let lines = readfile(expand("$VIMRUNTIME/rgb.txt"))
  call filter(lines, "v:val !~# '^\s*\d'")
  call filter(lines, 'len(split(v:val)) is# 4')
  return map(lines, 'split(v:val)[-1]')
endfunction
"}}}

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

let s:conf_default = {
      \ '__loaded_default_config': 0,
      \ '__loaded_special_parts': 0,
      \ '__loaded_theme': 0,
      \ 'color': {},
      \ }

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
  if !has_key(s:EB, 'alias')
    return
  endif
  call map(s:Parts.__layout, 'get(s:EB.alias, v:val, v:val)')
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
  if !get(s:EB, '__loaded_theme')
    call self.load_theme(get(s:EB, 'theme', 'default'))
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
        \ '__layout':   self.normalize_layout(s:EB[ a:active ? 'active' : 'inactive' ]),
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
  let s:EB.__loaded_theme = 1

  let theme = ezbar#theme#load(a:theme)
  let theme = deepcopy(get(theme, has_key(theme, &background) ? &background : 'dark' ))
  call extend(g:ezbar.color, self._normalize_theme(theme))
endfunction

function! s:ez._normalize_theme(theme) "{{{1
  let default_color = get(a:theme, 'm_normal')

  let colors = {}
  for color in split('m_normal m_insert m_visual m_replace m_command m_select m_other')
    let _color1 = get(a:theme, color, default_color)
    let colors[color . '_1'] = _color1
    let _color1_rev = s:Helper.reverse(_color1)
    let colors[color . '_2'] = has_key(a:theme, '_2')
          \ ? s:Helper.merge(_color1_rev, a:theme['_2'])
          \ : _color1_rev
    let colors[color . '_3'] = has_key(a:theme, '_3')
          \ ? s:Helper.merge(_color1_rev, a:theme['_3'])
          \ : _color1_rev
  endfor
  return extend(a:theme, colors, 'keep')
endfunction

function! s:ez.join() "{{{1
  return join(map(s:Parts.__layout, "printf('%%#%s#%s', v:val.color_name, v:val.s)"), '')
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
    if s ==# '%=' | return idx | endif
  endfor
  return -1
endfunction
"}}}

" API:
function! ezbar#string(active, winnr) "{{{1
  let s:EB     = g:ezbar
  if !get(s:EB, '__loaded_default_config') && g:ezbar_enable_default_config
    call extend(s:EB, ezbar#config#default#get(), 'keep')
    let s:EB.__loaded_default_config = 1
  endif

  let s:Parts  = s:EB.parts
  call s:Helper.__init()

  if ! s:_.is_Dictionary(get(g:ezbar, 'color'))
    let g:ezbar.color = {}
  endif

  try
    call s:ez.setup(a:active, a:winnr)
    let s = ''
    let s = s:ez.prepare().insert_separator().join()

  catch
    echom v:exception
  finally
    return s
  endtry
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

function! ezbar#color_check() range "{{{1
  " clear color
  call map(
        \ filter(getmatches(), 'v:val.group =~# "EzBar"'),
        \ 'matchdelete(v:val.id)')

  " call s:hl_color_names()
  for n in range(a:firstline, a:lastline)
    let line = getline(n)
    let colors = s:scan(line, '\v\c(#[a-f0-9]{6})')
    if empty(colors) | continue | endif
    " for c in colors
      " call matchadd(s:ez.hlmanager.register({ "gui": [ c, '#fafafa' ] }), c)
    " endfor
    let color = s:extract_color_definition(line)
    " echo color
    if empty(color) | continue | endif
    call matchadd(s:ez.hlmanager.register(eval(color)), '\V' . color)
  endfor
endfunction

function! s:scan(str, pattern) "{{{1
  let ret = []
  let pattern = a:pattern
  let nth = 1
  while 1
    let m = matchlist(a:str, pattern, 0, nth)
    if empty(m)
      break
    endif
    call add(ret, m[1])
    let nth += 1
  endwhile
  return ret
endfunction

function! ezbar#color_capture(color) "{{{1
  let R = s:ez.hlmanager.convert_full(a:color)
  call setreg(v:register, string(R), 'V')
endfunction

function! ezbar#load_theme(theme) "{{{1
  call s:ez.load_theme(a:theme)
endfunction

function! ezbar#color_names() "{{{1
  return s:color_names()
endfunction

function! ezbar#color_name2rgb() "{{{1
  return s:color_name2rgb()
endfunction
"}}}

call s:ez.init()

" if expand("%:p") !=# expand("<sfile>:p")
  " finish
" endif
" nnoremap <F10> :%EzbarColorCheck<CR>
" nnoremap <silent> <F9> :<C-u>execute 'EzbarColorCapture ' . expand('<cword>')<CR>

" vim: foldmethod=marker

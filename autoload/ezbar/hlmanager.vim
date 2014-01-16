let s:TYPE_STRING     = type('')
let s:TYPE_DICTIONARY = type({})
let s:TYPE_NUMBER     = type(0)
let s:GUI = has("gui_running")
let s:SCREEN = has("gui_running") ? 'gui' : 'cterm'

function! s:ensure(expr, exception) "{{{1
  if !a:expr
    throw a:exception
  endif
endfunction
"}}}

let s:hlmgr = {}

function! s:hlmgr.init(prefix) "{{{1
  let self._store  = {}
  let self._prefix  = a:prefix
  let self.named = empty(a:prefix)
  return self
endfunction

function! s:hlmgr.register(color, ...) "{{{1
  " use hlexists() ?
  if self.named
    call s:ensure(!empty(a:000), 'HLMANAGER_NEED_COLOR_NAME')

    let name = a:1
    if has_key(self._store, name) | return name | endif
    let defstr = self.hl_defstr(a:color)
  else
    call s:ensure(empty(a:000), 'HLMANAGER_COLOR_NAME_NOT_ALLOWED')
    if type(a:color) is s:TYPE_STRING
      return a:color
    endif

    let defstr = self.hl_defstr(a:color)
    let name = self.find_name(defstr)
    if !empty(name) | return name | endif
    let name = self.color_name_next()
  endif

  return self.define(name, { 'data': a:color, 'defstr': defstr })
endfunction

" function! s:hlmgr.register_with_capture(color_name) "{{{1
  " call s:ensure(type(a:color_name) is s:TYPE_STRING)
  " let color = self.convert(a:color_name)
  " return self.define(name, { 'data': a:color, 'defstr': defstr })
" endfunction

function! s:hlmgr.define(name, data) "{{{1
  let self._store[a:name]  = a:data
  execute s:hlmgr.command(a:name, a:data.defstr)
  return a:name
endfunction

function! s:hlmgr.find_name(defstr) "{{{1
  for [name, color] in items(self._store)
    if color.defstr ==# a:defstr
      return name
    endif
  endfor
  return ''
endfunction

function! s:hlmgr.command(name, defstr) "{{{1
  return printf('highlight %s %s', a:name, a:defstr)
endfunction

function! s:hlmgr.refresh() "{{{1
  for [name, color] in items(self._store)
    call self.define(name, color)
  endfor
endfunction

function! s:hlmgr.color_name_next() "{{{1
  return printf( self._prefix . '%03d', len(self._store))
endfunction
"}}}

" FIXED:
function! s:hlmgr.reset() "{{{1
  call self.clear()
  call self.init(self._prefix)
endfunction

function! s:hlmgr.get_color(color) "{{{1
  return get(self._store, a:color, '')
endfunction

function! s:hlmgr.parse(defstr, ...) "{{{1
  " return dictionary from string
  " 'guifg=#25292c guibg=#afb0ae' =>  {'gui': ['#afb0ae', '#25292c']}
  let R = {}
  if empty(a:defstr) | return R | endif

  let screens = empty(a:000) ? [s:SCREEN] : [ 'gui', 'cterm' ]
  for screen in screens
    let R[screen] = ['','']
    for def in split(a:defstr)
      let [key,val] = split(def, '=')
      if     key ==# screen . 'bg' | let R[screen][0]   = val
      elseif key ==# screen . 'fg' | let R[screen][1]   = val
      elseif key ==# screen        | call add(R[screen], val)
      endif
    endfor
  endfor
  return R
endfunction

function! s:hlmgr.parse_full(defstr) "{{{1
  return self.parse(a:defstr, 1)
endfunction

function! s:hlmgr.capture(hlname) "{{{1
  let hlname = a:hlname

  while 1
    redir => HL_SAVE
    execute 'silent! highlight ' . hlname
    redir END
    if !empty(matchstr(HL_SAVE, 'xxx cleared$'))
      return ''
    endif
    " follow highlight link
    let ml = matchlist(HL_SAVE, 'xxx links to \zs.*')
    if !empty(ml)
      let hlname = ml[0]
      continue
    endif
    break
  endwhile
  return matchstr(HL_SAVE, 'xxx \zs.*')
endfunction


function! s:hlmgr.clear() "{{{1
  for color in self.colors()
    execute 'highlight clear' color
  endfor
endfunction

function! s:hlmgr.colors() "{{{1
  return keys(self._store)
endfunction

function! s:hlmgr.hl_defstr(color) "{{{1
  " return 'guibg=DarkGreen gui=bold' (Type: String)
  let R = []
  let screen = s:GUI ? 'gui' : 'cterm'
  " let screen =  'cterm'

  let color = a:color[screen]
  "[NOTE] empty() is not appropriate, cterm color is specified with number
  for [idx, s] in [[ 0, 'bg' ], [ 1, 'fg' ] ,[ 2, ''] ]
    let c = get(color, idx, -1)
    if type(c) is s:TYPE_STRING && empty(c)
      continue
    elseif type(c) is s:TYPE_NUMBER && c ==# -1
      continue
    endif
    call add(R, printf('%s%s=%s', screen, s, color[idx]))
  endfor
  return join(R)
endfunction

function! s:hlmgr.convert(hlname) "{{{1
  return self.parse(self.capture(a:hlname))
endfunction

function! s:hlmgr.convert_full(hlname) "{{{1
  return self.parse_full(self.capture(a:hlname))
endfunction

function! s:hlmgr.dump() "{{{1
  return PP(self)
endfunction

function! ezbar#hlmanager#new(prefix) "{{{1
  return deepcopy(s:hlmgr).init(a:prefix)
endfunction "}}}
" vim: foldmethod=marker

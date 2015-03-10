" Util:
let s:_ = ezbar#util#get()
let s:SCREEN = s:_.screen_type()

" Main:
let s:hlmgr = {}

function! s:hlmgr.new(prefix) "{{{1
  let R = deepcopy(self)
  call R.init(a:prefix)
  return R
endfunction

function! s:hlmgr.init(prefix) "{{{1
  let self._colors     = {}
  let self._spec2color = {}
  let self.prefix      = a:prefix
  return self
endfunction

function! s:hlmgr.register(color) "{{{1
  if s:_.is_String(a:color)
    return a:color
  endif

  let spec = string(a:color[s:SCREEN])
  if s:_.is_Dictionary(a:color)
    let name = get(self._spec2color, spec, '')
    if !empty(name)
      " If color is already defined for spec provided.
      " return that color
      return name
    endif
  endif

  let name = self.color_next()
  call self.define(name, a:color)
  let self._colors[name]     = a:color
  let self._spec2color[spec] = name
  return name
endfunction

function! s:hlmgr.define(name, color) "{{{1
  let command = printf('highlight %s %s', a:name, self.hl_defstr(a:color))
  silent execute command
endfunction

function! s:hlmgr.refresh() "{{{1
  for [name, color] in items(self._colors)
    call self.define(name, color)
  endfor
endfunction

function! s:hlmgr.color_next() "{{{1
  return printf(self.prefix . '%05d', len(self._colors))
endfunction

function! s:hlmgr.reset() "{{{1
  call self.clear()
  call self.init(self.prefix)
endfunction

function! s:hlmgr.spec_for(color) "{{{1
  return get(self._colors, a:color, '')
endfunction

function! s:hlmgr.parse(spec, ...) "{{{1
  " return dictionary from string
  " 'guifg=#25292c guibg=#afb0ae' =>  {'gui': ['#afb0ae', '#25292c']}
  let R = {}
  if empty(a:spec)
    return R
  endif

  let screens = empty(a:000) ? [s:SCREEN] : ['gui', 'cterm' ]
  for screen in screens
    let R[screen] = ['','']
    for def in split(a:spec)
      let [key,val] = split(def, '=')
      if     key ==# screen . 'bg' | let R[screen][0]   = val
      elseif key ==# screen . 'fg' | let R[screen][1]   = val
      elseif key ==# screen        | call add(R[screen], val)
      endif
    endfor
  endfor
  return R
endfunction

function! s:hlmgr.parse_full(spec) "{{{1
  return self.parse(a:spec, 1)
endfunction

function! s:hlmgr.capture(hlname) "{{{1
  let hlname = a:hlname

  if empty(hlID(hlname))
    " if hl not exists, return empty string
    return ''
  endif

  redir => HL_SAVE
  execute 'silent! highlight ' . hlname
  redir END
  if !empty(matchstr(HL_SAVE, 'xxx cleared$'))
    return ''
  endif

  " follow highlight link
  let link = matchstr(HL_SAVE, 'xxx links to \zs.*')
  if !empty(link)
    return self.capture(link)
  endif

  return matchstr(HL_SAVE, 'xxx \zs.*')
endfunction

function! s:hlmgr.clear() "{{{1
  for color in self.colors()
    silent execute 'highlight clear' color
  endfor
endfunction

function! s:hlmgr.colors() "{{{1
  return keys(self._colors)
endfunction

function! s:hlmgr.hl_defstr(color) "{{{1
  " return 'guibg=DarkGreen gui=bold' (Type: String)
  let color = a:color[s:SCREEN]
  let R = []
  "[NOTE] empty() is not appropriate, cterm color is specified with number
  for [idx, s] in [[ 0, 'bg' ], [ 1, 'fg' ] ,[ 2, ''] ]
    let c = get(color, idx, -1)
    if (s:_.is_String(c) && empty(c)) || (s:_.is_Number(c) && c ==# -1)
      continue
    endif
    call add(R, printf('%s%s=%s', s:SCREEN, s, color[idx]))
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
"}}}

" API:
function! ezbar#hlmanager#new(prefix) "{{{1
  return s:hlmgr.new(a:prefix)
endfunction
"}}}

" vim: foldmethod=marker

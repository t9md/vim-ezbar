let s:h = {}
let s:TYPE_STRING     = type('')
let s:TYPE_DICTIONARY = type({})
let s:TYPE_NUMBER     = type(0)

let s:gui = has("gui_running") 

function! s:h.init() "{{{1
  let self.hls       = {}
  let self.match_ids = []
  return self
endfunction

function! s:h.hlname_for(defstr) "{{{1
  for [hlname, defstr] in items(self.hls)
    if defstr == a:defstr
      return hlname
    endif
  endfor
  return ''
endfunction

function! s:h.capture(hlname) "{{{1
  let hlname = a:hlname
  while 1
    redir => HL_SAVE
    execute 'silent! highlight ' . hlname
    redir END
    if !empty(matchstr(HL_SAVE, 'xxx cleared$'))
      return ''
    endif
    let ml = matchlist(HL_SAVE, 'xxx links to \zs.*')
    if !empty(ml)
      let hlname = ml[0]
      continue
    endif
    break
  endwhile
  return matchstr(HL_SAVE, 'xxx \zs.*')
endfunction

function! s:h.parse(defstr) "{{{1
  let R = {}
  if empty(a:defstr)
    return R
  endif
  let screen = s:gui ? 'gui' : 'cterm'
  " let screen = 'cterm'
  let R[screen] = ['','']
  for def in split(a:defstr)
    let [key,val] = split(def, '=')
    if screen ==# 'gui'
      if     key ==# 'guibg'   | let R['gui'][0]   = val
      elseif key ==# 'guifg'   | let R['gui'][1]   = val
      elseif key ==# 'gui'     | call add(R['gui'],val)
      endif
    else
      if     key ==# 'ctermbg' | let R['cterm'][0] = val
      elseif key ==# 'ctermfg' | let R['cterm'][1] = val
      elseif key ==# 'cterm'   | call add(R['cterm'],val) 
      endif
    endif
  endfor
  return R
endfunction

function! s:h.register(color) "{{{1
  if empty(a:color)
    return ''
  endif

  if type(a:color) ==# s:TYPE_STRING
    return a:color
    if has_key(self.hls, a:color)
      return a:color
    endif
    let parsed = self.parse(self.capture(a:color))
    if empty(parsed)
      return ''
    endif
    let color = parsed
  else
    let color = a:color
  endif
  let defstr = self.hl_defstr(color)

  let hlname = self.hlname_for(defstr)
  if empty(hlname)
    let hlname = get(color, 'name', self.next_color())
    call self.define(hlname, defstr)
  endif
  return hlname
endfunction

function! s:h.define(hlname, defstr) "{{{1
  silent execute self.command(a:hlname, a:defstr)
endfunction

function! s:h.command(hlname, defstr) "{{{1
  let self.hls[a:hlname] = a:defstr
  return printf('highlight %s %s', a:hlname, a:defstr)
endfunction

function! s:h.refresh() "{{{1
  " FIXME: after color_scheme was changed not re-captured predefined color
  " which is originally passed as String and converted to color dict form
  let colors = deepcopy(self.hls)
  call self.reset()
  for [hlname, defstr] in items(colors)
    call self.define(hlname, defstr)
  endfor
endfunction

function! s:h.next_color() "{{{1
  return printf( self.hl_prefix . '%03d', self.next_index())
endfunction

function! s:h.next_index() "{{{1
  return len(self.hls)
endfunction

function! s:h.clear() "{{{1
  for hl in self.colors()
    execute 'highlight ' . hl . ' NONE'
  endfor
endfunction

function! s:h.reset() "{{{1
  call self.clear()
  call self.init()
endfunction

function! s:h.list() "{{{1
  for hl in self.colors()
    execute 'highlight ' . hl
  endfor
endfunction

function! s:h.list_define() "{{{1
  let s = []
  for [hlname, defstr] in items(self.hls)
    call add(s, self.command(hlname, defstr))
  endfor
  return s
endfunction

function! s:h.colors() "{{{1
  return keys(self.hls)
endfunction

function! s:h.matchadd(group, pattern, ...) "{{{1
  let args = [ a:group, a:pattern ]
  if a:0 && type(a:1) ==# s:TYPE_NUMBER
    call add(args, a:1)
  endif
  let id = call('matchadd', args)
  call add(self.match_ids, id)
  return id
endfunction

function! s:h.matchdelete_all() "{{{1
  for id in self.match_ids
    call matchdelete(id)
  endfor
endfunction

function! s:h.matchdelete_ids(ids) "{{{1
  for id in a:ids
    call matchdelete(id)
  endfor
endfunction

function! s:h.hl_defstr(color) "{{{1
  let R = []
  for key in [ s:gui ? 'gui' : 'cterm' ]
    if empty(get(a:color, key))
      continue
    endif
    let color = a:color[key]
    " [NOTE] empty() is not appropriate, cterm color is specified with number
    for [n, s] in [[ 0, 'bg=' ], [ 1, 'fg=' ] ,[ 2, '='] ]
      let c = get(color, n, -1)
      if type(c) ==# s:TYPE_STRING && empty(c)
        continue
      elseif type(c) ==# s:TYPE_NUMBER && c ==# -1
        break
      endif
      call add(R, key . s . color[n])
    endfor
  endfor
  return join(R)
endfunction "}}}

function! s:h.dump() "{{{1
  return PP(self)
endfunction

function! s:h.our_match() "{{{
  return filter(getmatches(), "v:val.group =~# '". self.hl_prefix . "'")
endfunction "}}}

function! ezbar#highlighter#new(hl_prefix) "{{{1
  let o = deepcopy(s:h).init()
  let o.hl_prefix = a:hl_prefix
  return o
endfunction "}}}
" call s:h.init()

" vim: foldmethod=marker

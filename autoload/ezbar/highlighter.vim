let h = {} | let s:h = h

function! h.init() "{{{1
  let self.hls = {}
  let self._hls = []
  return self
endfunction

function! h.get_name(lis) "{{{1
  if type(a:lis) == type('')
    return a:lis
  endif
  let keyname = self.key_name_for(a:lis)
  if !has_key(self.hls, keyname)
    call self.register(a:lis)
  endif
  return self.hls[keyname]
endfunction

function! h.key_name_for(lis) "{{{1
  return join(a:lis, '_')
endfunction

function! h.register(lis) "{{{1
  let hlname = self.next_color()
  let cmd = printf('highlight %s guibg=%s guifg=%s', 
        \ hlname, a:lis[0], a:lis[1])
  execute cmd
  let self.hls[self.key_name_for(a:lis)] = hlname
  call add(self._hls, a:lis )
endfunction

function! h.refresh() "{{{1
  call self.clear()
  let colors = deepcopy(self._hls)
  let self._hls = []
  for color in colors
    call self.register(color)
  endfor
endfunction

function! h.next_color() "{{{1
  return printf('EzBar%03d', self.next_index())
endfunction

function! h.next_index() "{{{1
  return len(self.hls)
endfunction

function! h.clear() "{{{1
  for hl in values(self.hls)
    execute 'highlight ' . hl . ' NONE'
  endfor
  let self.hls = {}
endfunction

function! h.list() "{{{1
  for hl in values(self.hls)
    execute 'highlight ' . hl
  endfor
endfunction

function! h.dump() "{{{1
  return PP(self)
endfunction

function! h.preview(first, last)
  " FIXME
  call clearmatches()

  for n in range(a:first, a:last)
    let line = getline(n)

    " let custom_color_pat = '\v\s*\zs[.*]\ze'
    let custom_color_pat = '\v\s*\zs\[.*]\ze'
    let color = matchstr(line, custom_color_pat)
    if !empty(color)
      let color_name = self.get_name(eval(color))
    else
      let predefined_pat = '\v''c'':\s*''\zs.{-}\ze'''
      let color_name = matchstr(line, predefined_pat)
    endif
    if !exists('color_name')
      continue
    endif
    call matchadd(color_name, '\%' . n . 'l')
  endfor
endfunction

function! ezbar#highlighter#new() "{{{1
  return deepcopy(s:h).init()
endfunction "}}}

" call h.init()
" echo h.get_name('SmallsCurrent')
" echo h.get_name(['snow', 'DarkSlateGray'])

" vim: foldmethod=marker

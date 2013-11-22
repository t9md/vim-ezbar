let h = {} | let s:h = h

function! h.init() "{{{1
  let self.hls = {}
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

function! h.key_name_for(lis)
  return join(a:lis, '_')
endfunction

function! h.register(lis) "{{{1
  let hlname = self.next_color()
  let cmd = printf('highlight %s guibg=%s guifg=%s', 
        \ hlname, a:lis[0], a:lis[1])
  execute cmd
  let self.hls[self.key_name_for(a:lis)] = hlname
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

function! ezbar#highlighter#new() "{{{1
  return deepcopy(s:h).init()
endfunction "}}}

" call h.init()
" echo h.get_name('SmallsCurrent')
" echo h.get_name(['snow', 'DarkSlateGray'])


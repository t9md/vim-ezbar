let ez = {} | let s:ez = ez

function! ez.init() "{{{1
  let self.hl = ezbar#highlighter#new()
endfunction

function! ez.prepare(win) "{{{1
  let g:ezbar.parts.__is_active = ( a:win ==# 'active' )
  if exists('*g:ezbar.parts._init')
    call g:ezbar.parts._init()
  endif

  let layout = self.normalize(a:win, g:ezbar[a:win].layout)
  call filter(layout, '!empty(v:val.s)')
  if exists('*g:ezbar.parts._filter')
    let layout = g:ezbar.parts._filter(layout)
  endif
  return layout
endfunction

function! ez.normalize(win, layout) "{{{1
  let r = []
  for part_name in a:layout
    call add(r, self.normalize_part(a:win, part_name))
  endfor
  return r
endfunction

function! ez.normalize_part(win, part_name) "{{{1
  let part = g:ezbar.parts[a:part_name]()
  if type(part) == type({})
    let d = part
  else
    let s = type(part) == type('') ? part : ''
    let d = { 's' : s }
  endif
  let d.name = a:part_name
  return d
endfunction

function! ez.color_of(win, part)
  let wc = a:win ==# 'active' ? 'ac' : 'ic'
  let color = 
        \ has_key(a:part,  wc) ? a:part[wc] :
        \ has_key(a:part, 'c') ? a:part['c'] :
        \ g:ezbar[a:win].default_color
  return self.hl.get_name(color)
endfunction

function! ez.string(win) "{{{1
  let layout = self.prepare(a:win)
  let r = ''
  let max_idx = len(layout)
  for idx in range(max_idx)
    unlet! part
    let part = layout[idx]
    let color = self.color_of(a:win, part)
    let s = '%#'. color . '# ' . part.s

    if part.s ==# '%='
      let r .= s
      continue
    endif

    let next = idx + 1
    if next != max_idx
      if color == self.color_of(a:win, layout[next])
        let sep = ' |'
      else
        let sep = ' '
      endif
    else
      let sep = ' '
    endif
    let r .= s
    let r .= sep
  endfor
  return r
endfunction

function! ez.dump() "{{{1
  return PP(self)
endfunction

function! ezbar#string(win) "{{{1
  return s:ez.string(a:win)
endfunction

function! ezbar#set() "{{{1
  let cwin = winnr()
  for n in range(1, winnr('$'))
    if n ==# cwin
      call setwinvar(n, '&statusline', '%!ezbar#string("active")')
    else
      call setwinvar(n, '&statusline', '%!ezbar#string("inactive")')
    endif
  endfor
endfunction

function! ezbar#update() "{{{1
  call setwinvar(winnr(), '&statusline', '%!ezbar#string("active")')
endfunction "}}}

function! ezbar#hl_refresh() "{{{1
  call s:ez.hl.refresh()
endfunction "}}}

function! ezbar#hl_preview(first, last) "{{{1
  call s:ez.hl.preview(a:first, a:last)
endfunction "}}}

function! ezbar#disable() "{{{1
  set statusline&
  for n in range(1, winnr('$'))
    call setwinvar(n, '&statusline', &statusline)
  endfor

  augroup EzBar
    autocmd!
  augroup END
endfunction "}}}

call s:ez.init()
" vim: foldmethod=marker

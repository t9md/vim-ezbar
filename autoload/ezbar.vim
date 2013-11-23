function! s:plog(msg) "{{{1
  cal vimproc#system('echo "' . PP(a:msg) . '" >> ~/vim.log')
endfunction

let ez = {} | let s:ez = ez
function! ez.init() "{{{1
  let self.hl = ezbar#highlighter#new()
endfunction

function! ez.prepare(win) "{{{1
  let g:ezbar.parts.__is_active = ( a:win ==# 'active' )
  let layout = self.normalize(a:win, g:ezbar[a:win].layout)
  call filter(layout, '!empty(v:val.s)')
  if type(get( g:ezbar.parts, '_filter')) == type(function('getchar'))
    let layout = g:ezbar.parts._filter(layout)
  endif
  call self.colorize(a:win, layout)
  return layout
endfunction

function! ez.normalize(win, layout) "{{{1
  let r = []
  for part in a:layout
    let d = self.normalize_part(a:win, g:ezbar.parts[part]() )
    let d.name = part
    call add(r, d)
  endfor
  return r
endfunction

function! ez.normalize_part(win, part) "{{{1
  let default_hl = g:ezbar[a:win].default_color
  if type(a:part) == type({})
    let d = a:part
  else
    let d = {}
    let d.s = type(a:part) == type('')
          \ ? a:part
          \ : ''
  endif
  return d
endfunction

function! ez.colorize(win, layout) "{{{1
  let default_hl = g:ezbar[a:win].default_color
  let color_key = a:win ==# 'active' ? 'ac' : 'ic'
  for part in a:layout
    if !has_key(part, color_key) && !has_key(part, 'c')
      let part.c = default_hl
    endif
  endfor
endfunction

function! ez.color_of(win, part)
  let color_key = a:win ==# 'active' ? 'ac' : 'ic'
  let color = get(a:part, color_key, get(a:part, 'c'))
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
" echo s:ez.string('active')
" call s:ez.init()
" echo s:ez.dump()
" echo PP( s:ez.string('active'))
" echo ez.string()
" vim: foldmethod=marker

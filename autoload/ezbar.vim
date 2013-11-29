function! s:plog(msg) "{{{1
  cal vimproc#system('echo "' . PP(a:msg) . '" >> ~/vim.log')
endfunction "}}}

let s:ez = {}

function! s:ez.init() "{{{1
  let self.default_color = {}
  let self.default_color.active   = 'StatusLine'
  let self.default_color.inactive = 'StatusLineNC'
  let self.hl = ezbar#highlighter#new('EzBar')
endfunction

function! s:ez.prepare(win) "{{{1
  let g:ezbar.parts.__is_active = ( a:win ==# 'active' )
  if exists('*g:ezbar.parts._init')
    call g:ezbar.parts._init()
  endif

  let layout = map( deepcopy(g:ezbar[a:win]),
        \ 'self.normalize_part(a:win, v:val)')

  call filter(layout, '!empty(v:val)')
  call filter(layout, '!empty(v:val.s)')

  if exists('*g:ezbar.parts._filter')
    let layout = g:ezbar.parts._filter(layout)
  endif
  return layout
endfunction

function! s:ez.normalize_part(win, part_name) "{{{1
  if type(a:part_name) ==# type({})
    if has_key(a:part_name, 'chg_color')
      let self.default_color[a:win] = a:part_name['chg_color']
      return
    elseif has_key(a:part_name, '__SEP__')
      let part =  { 'name': '__SEP__', 's': '%=', 'c': a:part_name['__SEP__'] }
    else
      return
    endif
  elseif type(a:part_name) ==# type('')
    let part = g:ezbar.parts[a:part_name]()
  endif

  if type(part) == type({})
    let d = part
  else
    let s = type(part) == type('') ? part : ''
    let d = { 's' : s }
  endif

  if empty(get(d, 'c'))
    let d.c = self.default_color[a:win]
  endif
  if !has_key(d, 'name')
    let d.name = a:part_name
  endif
  return d
endfunction

function! s:ez.color_of(win, part)
  let wc = a:win ==# 'active' ? 'ac' : 'ic'
  let color = has_key(a:part,  wc) ? a:part[wc] : a:part.c
  return self.hl.register(color)
endfunction

function! s:ez.string(win) "{{{1
  let self.current_sec = 'left'
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
      let self.current_sec = 'right'
      continue
    endif

    let next = idx + 1
    if next != max_idx
      if color == self.color_of(a:win, layout[next])
        if self.current_sec == 'left'
          let sep = ' |'
          " let sep = ' ＞'
        else
          let sep = ' |'
          " let sep = ' ＜'
        endif
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
" PP g:ezbar['active']

function! s:ez.dump() "{{{1
  return PP(self)
endfunction

function! ezbar#string(win) "{{{1
  return s:ez.string(a:win)
endfunction

function! ezbar#set() "{{{1
  for n in range(1, winnr('$'))
    if n ==# winnr()
      call setwinvar(n, '&statusline', '%!ezbar#string("active")')
    else
      call setwinvar(n, '&statusline', '%!ezbar#string("inactive")')
    endif
  endfor
endfunction

function! ezbar#update() "{{{1
  call setwinvar(winnr(), '&statusline', '%!ezbar#string("active")')
endfunction

function! ezbar#hl_refresh() "{{{1
  call s:ez.hl.refresh()
endfunction

function! ezbar#hl_preview(first, last) "{{{1
  call s:ez.hl.preview(a:first, a:last)
endfunction

function! ezbar#get_highlighter() "{{{1
  return s:ez.hl
endfunction

function! ezbar#disable() "{{{1
  silent set statusline&
  for n in range(1, winnr('$'))
    call setwinvar(n, '&statusline', &statusline)
  endfor

  augroup EzBar
    autocmd!
  augroup END
endfunction "}}}

call s:ez.init()

" echo s:ez.string('active')
" echo s:ez.string('inactive')
" vim: foldmethod=marker

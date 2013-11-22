function! s:plog(msg) "{{{1
  cal vimproc#system('echo "' . PP(a:msg) . '" >> ~/vim.log')
endfunction
let ez = {} | let s:ez = ez
function! ez.init() "{{{1
  let self.hl = ezbar#highlighter#new()
endfunction

function! ez.prepare(win) "{{{1
  let layout = []
  let win = a:win
  let default_hl = self.hl.get_name(g:ezbar[win].default_color)
  let sep_hl = self.hl.get_name( get(g:ezbar[win], 'sep_color', default_hl) )

  for part in g:ezbar[win].layout
    if part == '__SEP__'
      call add(layout, { 's': '%=', 'c': sep_hl })
    else
      unlet! p
      let p = g:ezbar.parts[part]()
      if empty(p)
        continue
      endif
      call add(layout, type(p) == type('') ? { 's': p, 'c': default_hl } : p  )
    endif
    unlet! part
  endfor
  return layout
endfunction

function! ez.string(win) "{{{1
  let layout = self.prepare(a:win)
  let r = ''
  let max_idx = len(layout)
  for idx in range(len(layout))
    unlet! part
    let part = layout[idx]
    let color = self.hl.get_name(part.c)
    let s = '%#'. color . '# ' . part.s

    if part.s ==# '%='
      let r .= s
      continue
    endif

    let next = idx + 1
    if next != max_idx
      if color == self.hl.get_name(layout[next].c)
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

call s:ez.init()
" echo s:ez.string('active')
" call s:ez.init()
" echo s:ez.dump()
" echo PP( s:ez.string('active'))
" echo ez.string()
" vim: foldmethod=marker

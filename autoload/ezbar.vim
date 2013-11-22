function! s:plog(msg) "{{{1
  cal vimproc#system('echo "' . PP(a:msg) . '" >> ~/vim.log')
endfunction
" %-0{minwid}.{maxwid}{item}

let ez = {} | let s:ez = ez
function! ez.init() "{{{1
  let self.hl = ezbar#highlighter#new()
endfunction

function! ez.prepare(win) "{{{1
  let r = []
  let s:default_f = ezbar#functions#default()
  let default_color = g:ezbar[a:win].default_color
  let default_color_name = self.name_of_hl(default_color)
  call extend(s:default_f, g:ezbar.functions , 'force')

  for part in g:ezbar[a:win].layout
    if part == '__SEP__'
      call add(r, '%#' . default_color_name . '#')
      call add(r, '%=')
    else
      unlet! p
      let p = s:default_f[part]()
      if empty(p)
        continue
      endif
      if type(p) == type('')
        let d = { 's': p, 'c': default_color_name }
      else
        let d = p
      endif
      call add(r, d)
    endif
  endfor
  return r
endfunction

function! ez.name_of_hl(hl)
  return self.hl.get_name(a:hl)
endfunction

function! ez.string(win) "{{{1
  let lis = self.prepare(a:win)
  let r = ''
  let last_color = ''
  let max_idx = len(lis)
  for idx in range(len(lis))
    unlet! v
    let v = lis[idx]
    if type(v) == type({})
      let color_name = self.name_of_hl(v.c)
      let s = '%#'. color_name . '# ' . v.s
    else
      let s = v
      let last_color = ''
      let r .= s
      continue
    endif
    let next = idx + 1
    if next != max_idx && type(lis[idx+1]) == type({})
      if color_name == self.name_of_hl(lis[next].c)
        let sep = ' |'
      else
        let sep = ' '
      endif
    else
      let sep = ' '
    endif
    let r .= s
    let r .= sep
    let last_color = color_name
  endfor
  return r
endfunction

function! ez.dump() "{{{1
  return PP(self)
endfunction

function! ezbar#string(win) "{{{1
  call s:ez.init()
  " return '%#SmallsCurrent#%(n%) %#Normal# vim %= %l/%L %p%%'
  return s:ez.string(a:win)
endfunction

function! ezbar#set() "{{{1
  call s:ez.init()
  let current_win = winnr()
  for n in range(1, winnr('$'))
    if n == current_win
      call setwinvar(n, '&statusline', '%!ezbar#string("active")')
    else
      call setwinvar(n, '&statusline', '%!ezbar#string("inactive")')
    endif
  endfor
endfunction
function! ezbar#update() "{{{1
  call s:ez.init()
  call setwinvar(winnr(), '&statusline', '%!ezbar#string("active")')
endfunction
call s:ez.init()
echo s:ez.dump()
" echo PP( s:ez.string('active'))
" echo ez.string()
" vim: foldmethod=marker

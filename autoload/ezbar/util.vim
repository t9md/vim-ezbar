" Util:
let s:util = {}

function! s:util.merge(color1, color2) "{{{1
  let R = []
  let color1 = copy(a:color1)
  let color2 = a:color2
  call add(R , (color2[0] isnot '' ) ? color2[0] : color1[0] )
  call add(R , (color2[1] isnot '' ) ? color2[1] : color1[1] )

  let c1 = get(color1, 2, '')
  let c2 = get(color2, 2, '')
  if c1 is '' && c2 is ''
    return R
  endif
  call add(R, (c2 isnot '') ? c2 : c1 )
  return R
endfunction

function! s:util.reverse(color) "{{{1
  let R = deepcopy(a:color)
  let screen = self.screen()
  let [ R[screen][0], R[screen][1] ] = [ R[screen][1], R[screen][0] ]
  return R
endfunction

function! s:util.invert_deco(color, decorate) "{{{1
  let screen = self.screen()
  let R = deepcopy(a:color)
  let deco = split(get(R[screen], 2, ''), ',')

  let index = index(deco, a:decorate)
  if index ==# -1
    call add(deco, a:decorate)
  else
    call remove(deco, index)
  endif
  let deco_s = join(deco, ',')
  if len(R[screen]) ==# 3
    let R[screen][2] = deco_s
  else
    call add(R[screen], deco_s)
  endif
  return R
endfunction

function! s:util.bg(color, color_new) "{{{1
  return self._color_change(a:color, a:color_new, 0)
endfunction

function! s:util.fg(color, color_new) "{{{1
  return self._color_change(a:color, a:color_new, 1)
endfunction

function! s:util.s(part) "{{{1
  let [EB, PARTS] = [ g:ezbar, g:ezbar.parts ]
  if has_key(PARTS.__parts, a:part)
    return PARTS.__parts[a:part].s
  else
    return ''
  endif
endfunction

function! s:util.c(part) "{{{1
  let [EB, PARTS] = [ g:ezbar, g:ezbar.parts ]
  if has_key(PARTS.__parts, a:part)
    return PARTS.__parts[a:part].c
  else
    return {}
  endif
endfunction

function! s:util._color_change(color, color_new, index)
  let screen = self.screen()
  let R = deepcopy(a:color)
  if !has_key(a:color_new, screen) | return R | endif
  let R[screen][a:index] = a:color_new[screen]
  return R
endfunction

function! s:util.screen() "{{{1
  return has('gui_running') ? 'gui' : 'cterm'
endfunction

function! ezbar#util#get() "{{{1
  return s:util
endfunction
"}}}

" vim: foldmethod=marker

let s:helper = {}

function! s:helper.merge(color1, color2) "{{{1
  let screen = self.screen()
  let color1 = copy(a:color1[screen])
  let color2 = a:color2[screen]

  let R = {}
  let R[screen] = []
  call add(R[screen] , (color2[0] isnot '' ) ? color2[0] : color1[0] )
  call add(R[screen] , (color2[1] isnot '' ) ? color2[1] : color1[1] )

  let c1 = get(color1, 2, '')
  let c2 = get(color2, 2, '')
  if c1 is '' && c2 is ''
    return R
  endif
  call add(R[screen], (c2 isnot '') ? c2 : c1 )
  return R
endfunction

function! s:helper.reverse(color) "{{{1
  let R = deepcopy(a:color)
  let screen = self.screen()
  let [ R[screen][0], R[screen][1] ] = [ R[screen][1], R[screen][0] ]
  return R
endfunction

function! s:helper.invert_deco(color, decorate) "{{{1
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

function! s:helper.bg(...) "{{{1
  return call(self._color_change, [0] + a:000, self)
endfunction

function! s:helper.fg(...) "{{{1
  return call(self._color_change, [1] + a:000, self)
endfunction

function! s:helper.s(part) "{{{1
  if has_key(g:ezbar.parts, a:part)
    return g:ezbar.parts[a:part].s
  else
    return ''
  endif
endfunction

function! s:helper.c(part) "{{{1
  if has_key(g:ezbar.parts, a:part)
    return g:ezbar.parts[a:part].c
  else
    return {}
  endif
endfunction

function! s:helper._color_change(...) "{{{1
  if a:0 ==# 2
    let [index, color, color_new ] = [ a:1, g:ezbar.parts.__c, a:2 ]
  elseif a:0 ==# 3
    let [index, color, color_new ] = a:000
  endif

  let screen = self.screen()
  let R = deepcopy(color)
  if !has_key(color_new, screen) | return R | endif
  let R[screen][index] = color_new[screen]
  return R
endfunction

function! s:helper.hide(...) "{{{1
  let list = get(a:000, 0, [])
  for [ limit, parts ] in items(g:ezbar.hide_rule)
    if g:ezbar.parts.__width < str2nr(limit)
      let list += parts
    endif
  endfor
  call filter(g:ezbar.parts.__layout, 'index(list, v:val) ==# -1')
endfunction

function! s:helper.screen() "{{{1
  return ezbar#util#is_guicolors() ? 'gui' : 'cterm'
endfunction

function! s:helper.convert(color) "{{{1
  return ezbar#hlmanager().convert(a:color)
endfunction

function! s:helper.getvar(varname) "{{{1
  return getwinvar(g:ezbar.parts.__winnr, a:varname)
endfunction
"}}}

" API:
function! ezbar#helper#get() "{{{1
  return s:helper
endfunction
"}}}

" vim: foldmethod=marker

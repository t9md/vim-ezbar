" API:
function! ezbar#theme#list(A, L, P) "{{{1
  let themes = map(
        \ split(globpath(&rtp , 'autoload/ezbar/theme/*.vim'), "\n"),
        \ 'fnamemodify(v:val, '':t:r'')'
        \ )
  return filter(themes, 'v:val =~ ''^' . a:A . '''')
endfunction

function! ezbar#theme#load(theme) "{{{1
  let _     = ezbar#helper#get()
  let theme = ezbar#theme#{a:theme}#load()
  let bg    = has_key(theme, &background) ? &background : 'dark'
  let theme = get(theme, bg)

  let R = {}
  let default_color = theme['m_normal']

  for c in [ "m_normal", "m_insert", "m_visual", "m_replace", "m_command", "m_select", "m_other" ]
    let c1  = get(theme, c, default_color)
    let c1r = _.reverse(c1)

    let R[c.'_1'] = c1
    let R[c.'_2'] = has_key(theme, '_2') ? _.merge(c1r, theme['_2']) : c1r
    let R[c.'_3'] = has_key(theme, '_3') ? _.merge(c1r, theme['_3']) : c1r
  endfor

  return extend(R, theme)
endfunction
"}}}
" vim: foldmethod=marker

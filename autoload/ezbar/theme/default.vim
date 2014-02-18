let s:theme = {}
let s:theme.dark = {
      \ 'm_normal':   {'gui': ['SkyBlue3',         'gray14'], 'cterm': [ 33, 16] },
      \ 'm_insert':   {'gui': ['PaleGreen3',       'gray14'], 'cterm': [ 10, 16] },
      \ 'm_visual':   {'gui': ['PaleVioletRed',    'gray14'], 'cterm': [  9, 16] },
      \ 'm_replace':  {'gui': ['tomato1',          'gray14'], 'cterm': [  1, 16] },
      \ 'm_command':  {'gui': ['MediumAquamarine', 'gray14'], 'cterm': [  9, 16] },
      \ 'm_select':   {'gui': ['MediumAquamarine', 'gray14'], 'cterm': [  9, 16] },
      \ 'm_other':    {'gui': ['MediumAquamarine', 'gray14'], 'cterm': [  9, 16] },
      \
      \ 'inactive': {'gui': ['gray23', 'gray68'], 'cterm': [ '', '', 'reverse'] },
      \ 'warn':     {'gui': ['OrangeRed2', 'AliceBlue'], 'cterm': [ 9,  16 ] },
      \ '_2':       {'gui': ['gray20', ''], 'cterm': ['gray', ''] },
      \ }
let s:theme.light = {
      \ 'm_normal':   {'gui': ['DodgerBlue4',      'white'], 'cterm': [ 33, 16] },
      \ 'm_insert':   {'gui': ['SeaGreen',         'white'], 'cterm': [ 10, 16] },
      \ 'm_visual':   {'gui': ['VioletRed',    'white'], 'cterm': [  9, 16] },
      \ 'm_replace':  {'gui': ['tomato1',          'white'], 'cterm': [  1, 16] },
      \ 'm_command':  {'gui': ['ForestGreen', 'white'], 'cterm': [  9, 16] },
      \ 'm_select':   {'gui': ['ForestGreen', 'white'], 'cterm': [  9, 16] },
      \ 'm_other':    {'gui': ['ForestGreen', 'white'], 'cterm': [  9, 16] },
      \
      \ 'inactive': {'gui': ['gray23',     'gray68'],    'cterm': [ '','','reverse'] },
      \ 'warn':     {'gui': ['OrangeRed2', 'AliceBlue'], 'cterm': [ 9,16 ] },
      \ '_2':   {'gui': ['ivory', ''],'cterm':['gray', '']   },
      \ '_3':   {'gui': ['#FFFFFF', ''],'cterm':['gray', '']   },
      \ }

" function! s:theme.setup(theme) "{{{1
  " let default_color = get(a:theme, 'm_normal')
  " let colors = {}
  " for color in split('m_normal m_insert m_visual m_replace m_command m_select m_other')
    " let _color1 = get(a:theme, color, default_color)
    " let colors[color . '_1'] = _color1
    " let _color1_rev = s:HELPER.reverse(_color1)
    " let colors[color . '_2'] = has_key(a:theme, '_2')
          " \ ? s:HELPER.merge(_color1_rev, a:theme['_2'])
          " \ : _color1_rev
    " let colors[color . '_3'] = has_key(a:theme, '_3')
          " \ ? s:HELPER.merge(_color1_rev, a:theme['_3'])
          " \ : _color1_rev
  " endfor
  " return extend(a:theme, colors, 'keep')
" endfunction

" let s:HELPER = ezbar#helper#get()

function! ezbar#theme#default#load()
  " call s:theme.setup(s:theme.dark)
  " call s:theme.setup(s:theme.light)
  return s:theme
endfunction

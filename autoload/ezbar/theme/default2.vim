let s:theme = {}
let s:theme.dark = {
      \ 'm_normal':   {'gui': ['DodgerBlue4',      'white'], 'cterm': [ 33, 16] },
      \ 'm_insert':   {'gui': ['SeaGreen',         'white'], 'cterm': [ 10, 16] },
      \ 'm_visual':   {'gui': ['VioletRed',    'white'], 'cterm': [  9, 16] },
      \ 'm_replace':  {'gui': ['tomato1',          'white'], 'cterm': [  1, 16] },
      \ 'm_command':  {'gui': ['ForestGreen', 'white'], 'cterm': [  9, 16] },
      \ 'm_select':   {'gui': ['ForestGreen', 'white'], 'cterm': [  9, 16] },
      \ 'm_other':    {'gui': ['ForestGreen', 'white'], 'cterm': [  9, 16] },
      \
      \ 'inactive': {'gui': ['gray23',     'gray68'],    'cterm': [ '','','reverse'] },
      \ 'warn':     {'gui': ['OrangeRed2', 'AliceBlue'], 'cterm': [ 9,16             ] },
      \ '_2':   {'gui': 'ivory',      'cterm':      'gray'   },
      \ '_3':   {'gui': '#FFFFFF',      'cterm':      'gray'   },
      \ }
function! ezbar#theme#default2#load()
  return s:theme
endfunction

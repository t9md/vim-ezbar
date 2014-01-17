let s:theme = {}
let s:theme.dark = {
      \ 'm_normal':   {'gui': ['SkyBlue3',         'gray14'], 'cterm': [ 33, 16] },
      \ 'm_insert':   {'gui': ['PaleGreen3',       'gray14'], 'cterm': [ 10, 16] },
      \ 'm_replace':  {'gui': ['tomato1',          'gray14'], 'cterm': [  1, 16] },
      \ 'm_visual':   {'gui': ['PaleVioletRed',    'gray14'], 'cterm': [  9, 16] },
      \ 'm_other':    {'gui': ['MediumAquamarine', 'gray14'], 'cterm': [  9, 16] },
      \
      \ 'inactive': {'gui': ['gray23',     'gray68'],    'cterm': [ '','','reverse'] },
      \ 'warn':     {'gui': ['OrangeRed2', 'AliceBlue'], 'cterm': [ 9,16             ] },
      \ '_2':   {'gui': 'gray25',      'cterm':      'gray'   },
      \ }
let s:theme.light = {
      \ 'm_normal':   {'gui': ['MediumBlue',    'white'], 'cterm': [33, 16] },
      \ 'm_insert':   {'gui': ['LimeGreen',     'white'], 'cterm': [10, 16] },
      \ 'm_replace':  {'gui': ['DeepPink',      'white'], 'cterm': [ 1, 16] },
      \ 'm_visual':   {'gui': ['DarkGoldenrod', 'white'], 'cterm': [ 9, 16] },
      \ 'm_other':    {'gui': ['LightSeaGreen', 'white'], 'cterm': [ 9, 16] },
      \
      \ 'inactive': {'gui': ['#586e75',    '#eee8d5'],   'cterm': ['', '', 'reverse']},
      \ 'warn':     {'gui': ['OrangeRed2', 'AliceBlue'], 'cterm': [    9,  16] },
      \ '_2':   {'gui': 'gray88',      'cterm':      251      },
      \ }

function! ezbar#themes#default#load()
  return s:theme[&background]
endfunction

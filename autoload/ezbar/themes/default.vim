let s:theme = {}
let s:theme.dark = {
      \ 'warn':       {'gui': ['OrangeRed2', 'AliceBlue'], 'cterm' :[ 9, 16] },
      \ 'statusline': {'gui': ['gray23',        'gray68'], 'cterm': ['', '', 'reverse'] },
      \ 'm_normal':   {'gui': ['SkyBlue3',      'gray14'], 'cterm': [33, 16] },
      \ 'm_insert':   {'gui': ['PaleGreen3',    'gray14'], 'cterm': [10, 16] },
      \ 'm_replace':  {'gui': ['tomato1',       'gray14'], 'cterm': [ 1, 16] },
      \ 'm_visual':   {'gui': ['PaleVioletRed', 'gray14'], 'cterm': [ 9, 16] },
      \ 'm_other':    {'gui': ['cyan1',         'gray14'], 'cterm': [ 9, 16] },
      \ }
let s:theme.light = {
      \ 'warn':       {'gui': ['OrangeRed2',    'AliceBlue'], 'cterm': [ 9, 16] },
      \ 'statusline': {'gui': ['#586e75',         '#eee8d5'], 'cterm': ['', '', 'reverse']},
      \ 'm_normal':   {'gui': ['MediumBlue',        'white'], 'cterm': [33, 16] },
      \ 'm_insert':   {'gui': ['LimeGreen',         'white'], 'cterm': [10, 16] },
      \ 'm_replace':  {'gui': ['DeepPink',          'white'], 'cterm': [ 1, 16] },
      \ 'm_visual':   {'gui': ['DarkGoldenrod',     'white'], 'cterm': [ 9, 16] },
      \ 'm_other':    {'gui': ['LightSeaGreen',     'white'], 'cterm': [ 9, 16] },
      \ }

function! ezbar#themes#default#load()
  return s:theme[&background]
endfunction

let s:theme = {}

let s:theme.dark = {
      \ 'm_normal':    { 'gui': ['#00005F', '#FFFFFF']},
      \ 'm_normal_2':  { 'gui': ['#545493', '#FFFFFF']},
      \ 'm_normal_3':  { 'gui': ['#2A2A79', '#FFFFFF']},
      \ 'm_insert':    { 'gui': ['#005F00', '#FFFFFF']},
      \ 'm_insert_2':  { 'gui': ['#549354', '#000000']},
      \ 'm_insert_3':  { 'gui': ['#2A792A', '#FFFFFF']},
      \ 'm_visual':    { 'gui': ['#FF5F00', '#000000']},
      \ 'm_visual_2':  { 'gui': ['#FF9354', '#000000']},
      \ 'm_visual_3':  { 'gui': ['#FF792A', '#000000']},
      \ 'm_replace':   { 'gui': ['#FF5F00', '#000000']},
      \ 'm_replace_2': { 'gui': ['#FF9354', '#000000']},
      \ 'm_replace_3': { 'gui': ['#FF792A', '#000000']},
      \ 'm_command':   { 'gui': ['#008700', '#FFFFFF']},
      \ 'm_command_2': { 'gui': ['#54AE54', '#000000']},
      \ 'm_command_3': { 'gui': ['#2A9A2A', '#000000']},
      \ 'm_select':    { 'gui': ['#008700', '#000000']},
      \ 'm_select_2':  { 'gui': ['#54AE54', '#000000']},
      \ 'm_select_3':  { 'gui': ['#2A9A2A', '#000000']},
      \ 'm_other':     { 'gui': ['#008700', '#000000']},
      \ 'm_other_2':   { 'gui': ['#54AE54', '#000000']},
      \ 'm_other_3':   { 'gui': ['#2A9A2A', '#000000']},
      \
      \ 'inactive': {'gui': ['gray23',     'gray68'],    'cterm': [ '','','reverse'] },
      \ 'warn':     {'gui': ['OrangeRed2', 'AliceBlue'], 'cterm': [ 9,16             ] },
      \ '_2':   {'gui': 'gray20',      'cterm':      'gray'   },
      \ }
" let s:theme.dark = {
      " \ 'm_normal':    { 'gui': ['#00005F', '#FFFFFF']},
      " \ 'm_normal_2':  { 'gui': ['#2A2A79', '#FFFFFF']},
      " \ 'm_normal_3':  { 'gui': ['#545493', '#FFFFFF']},
      " \ 'm_insert':    { 'gui': ['#005F00', '#FFFFFF']},
      " \ 'm_insert_2':  { 'gui': ['#2A792A', '#FFFFFF']},
      " \ 'm_insert_3':  { 'gui': ['#549354', '#000000']},
      " \ 'm_visual':    { 'gui': ['#FF5F00', '#000000']},
      " \ 'm_visual_2':  { 'gui': ['#FF792A', '#000000']},
      " \ 'm_visual_3':  { 'gui': ['#FF9354', '#000000']},
      " \ 'm_replace':   { 'gui': ['#FF5F00', '#000000']},
      " \ 'm_replace_2': { 'gui': ['#FF792A', '#000000']},
      " \ 'm_replace_3': { 'gui': ['#FF9354', '#000000']},
      " \ 'm_command':   { 'gui': ['#008700', '#FFFFFF']},
      " \ 'm_command_2': { 'gui': ['#2A9A2A', '#000000']},
      " \ 'm_command_3': { 'gui': ['#54AE54', '#000000']},
      " \ 'm_select':    { 'gui': ['#008700', '#000000']},
      " \ 'm_select_2':  { 'gui': ['#2A9A2A', '#000000']},
      " \ 'm_select_3':  { 'gui': ['#54AE54', '#000000']},
      " \ 'm_other':     { 'gui': ['#008700', '#000000']},
      " \ 'm_other_2':   { 'gui': ['#2A9A2A', '#000000']},
      " \ 'm_other_3':   { 'gui': ['#54AE54', '#000000']},
      " \
      " \ 'inactive': {'gui': ['gray23',     'gray68'],    'cterm': [ '','','reverse'] },
      " \ 'warn':     {'gui': ['OrangeRed2', 'AliceBlue'], 'cterm': [ 9,16             ] },
      " \ '_2':   {'gui': 'gray20',      'cterm':      'gray'   },
      "
let s:theme.light = {
      \ 'm_normal':   {'gui': ['MediumBlue',    'white'], 'cterm': [33, 16] },
      \ 'm_insert':   {'gui': ['LimeGreen',     'white'], 'cterm': [10, 16] },
      \ 'm_replace':  {'gui': ['DeepPink',      'white'], 'cterm': [ 1, 16] },
      \ 'm_visual':   {'gui': ['DarkGoldenrod', 'white'], 'cterm': [ 9, 16] },
      \ 'm_command':  {'gui': ['LightSeaGreen', 'white'], 'cterm': [ 9, 16] },
      \ 'm_select':   {'gui': ['LightSeaGreen', 'white'], 'cterm': [ 9, 16] },
      \ 'm_other':    {'gui': ['LightSeaGreen', 'white'], 'cterm': [ 9, 16] },
      \
      \ 'inactive': {'gui': ['#586e75',    '#eee8d5'],   'cterm': ['', '', 'reverse']},
      \ 'warn':     {'gui': ['OrangeRed2', 'AliceBlue'], 'cterm': [    9,  16] },
      \ '_2':   {'gui': 'gray88',      'cterm':      251      },
      \ }

function! ezbar#theme#gradation#get()
  return s:theme
endfunction

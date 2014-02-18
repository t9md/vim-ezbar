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
      \ '_2':   {'gui': ['gray20', ''],'cterm':['gray', '']   },
      \ }
function! ezbar#theme#gradation#load()
  return s:theme
endfunction

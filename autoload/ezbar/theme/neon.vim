let s:theme = {}
let s:theme.dark = {
      \ 'm_normal':    { 'gui': ['#000000', '#ab82ff'] },
      \ 'm_normal_1':  { 'gui': ['#ab82ff', '#000000'] },
      \ 'm_normal_2':  { 'gui': ['#1f1f1f', '#ba55d3'] },
      \ 'm_normal_3':  { 'gui': ['#000000', '#ba55d3'] },
      \ 'm_insert':    { 'gui': ['#000000', '#00ff7f'] },
      \ 'm_insert_1':  { 'gui': ['#9aff9a', '#000000'] },
      \ 'm_insert_2':  { 'gui': ['#1f1f1f', '#00cd66'] },
      \ 'm_insert_3':  { 'gui': ['#000000', '#00cd66'] },
      \ 'm_visual':    { 'gui': ['#000000', '#ffb90f'] },
      \ 'm_visual_1':  { 'gui': ['#ffb90f', '#000000'] },
      \ 'm_visual_2':  { 'gui': ['#1f1f1f', '#ffd700'] },
      \ 'm_visual_3':  { 'gui': ['#000000', '#ffd700'] },
      \ 'm_replace':   { 'gui': ['#000000', '#ff1493'] },
      \ 'm_replace_1': { 'gui': ['#ff6eb4', '#000000'] },
      \ 'm_replace_2': { 'gui': ['#1f1f1f', '#cd1076'] },
      \ 'm_replace_3': { 'gui': ['#000000', '#cd1076'] },
      \ 'm_command':   { 'gui': ['#000000', '#54AE54'] },
      \ 'm_command_1': { 'gui': ['#7EC27E', '#000000'] },
      \ 'm_command_2': { 'gui': ['#1f1f1f', '#A9D6A9'] },
      \ 'm_command_3': { 'gui': ['#000000', '#A9D6A9'] },
      \ 'm_select':    { 'gui': ['#000000', '#54AE54'] },
      \ 'm_select_1':  { 'gui': ['#7EC27E', '#000000'] },
      \ 'm_select_2':  { 'gui': ['#1f1f1f', '#A9D6A9'] },
      \ 'm_select_3':  { 'gui': ['#000000', '#A9D6A9'] },
      \ 'm_other':     { 'gui': ['#000000', '#54AE54'] },
      \ 'm_other_1':   { 'gui': ['#7EC27E', '#000000'] },
      \ 'm_other_2':   { 'gui': ['#1f1f1f', '#A9D6A9'] },
      \ 'm_other_3':   { 'gui': ['#000000', '#A9D6A9'] },
      \
      \ 'inactive': {'gui': ['gray23',     'gray68'],    'cterm': [ '','','reverse'] },
      \ 'warn':     {'gui': ['OrangeRed2', 'AliceBlue'], 'cterm': [ 9,16             ] },
      \ }
function! ezbar#theme#neon#load()
  return s:theme
endfunction

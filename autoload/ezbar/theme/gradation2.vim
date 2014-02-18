let s:theme = {}

let s:theme.dark = {
      \ 'm_normal':    { 'gui': ['#545493', '#FFFFFF'] },
      \ 'm_normal_2':  { 'gui': ['#7E7EAE', '#000000'] },
      \ 'm_normal_3':  { 'gui': ['#A9A9C9', '#000000'] },
      \ 'm_insert':    { 'gui': ['#549354', '#FFFFFF'] },
      \ 'm_insert_2':  { 'gui': ['#7EAE7E', '#000000'] },
      \ 'm_insert_3':  { 'gui': ['#A9C9A9', '#000000'] },
      \ 'm_visual':    { 'gui': ['#FF9354', '#000000'] },
      \ 'm_visual_2':  { 'gui': ['#FFAE7E', '#000000'] },
      \ 'm_visual_3':  { 'gui': ['#FFC9A9', '#000000'] },
      \ 'm_replace':   { 'gui': ['#FF9354', '#000000'] },
      \ 'm_replace_2': { 'gui': ['#FFAE7E', '#000000'] },
      \ 'm_replace_3': { 'gui': ['#FFC9A9', '#000000'] },
      \ 'm_command':   { 'gui': ['#54AE54', '#000000'] },
      \ 'm_command_2': { 'gui': ['#7EC27E', '#000000'] },
      \ 'm_command_3': { 'gui': ['#A9D6A9', '#000000'] },
      \ 'm_select':    { 'gui': ['#54AE54', '#000000'] },
      \ 'm_select_2':  { 'gui': ['#7EC27E', '#000000'] },
      \ 'm_select_3':  { 'gui': ['#A9D6A9', '#000000'] },
      \ 'm_other':     { 'gui': ['#54AE54', '#000000'] },
      \ 'm_other_2':   { 'gui': ['#7EC27E', '#000000'] },
      \ 'm_other_3':   { 'gui': ['#A9D6A9', '#000000'] },
      \
      \ 'inactive': {'gui': ['gray23',     'gray68'],    'cterm': [ '','','reverse'] },
      \ 'warn':     {'gui': ['OrangeRed2', 'AliceBlue'], 'cterm': [ 9,16             ] },
      \ }
function! ezbar#theme#gradation2#load()
  return s:theme
endfunction

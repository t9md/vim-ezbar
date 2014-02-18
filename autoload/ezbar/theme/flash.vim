let s:theme = {}
let s:theme.dark = {
      \ 'm_normal':    { 'gui': ['#00688B', '#ffffff'] },
      \ 'm_normal_1':  { 'gui': ['#BFD9E2', '#00688B'] },
      \ 'm_normal_2':  { 'gui': ['#3F8DA8', '#ffffff'] },
      \ 'm_normal_3':  { 'gui': ['#00688B', '#ffffff'] },
      \ 'm_insert':    { 'gui': ['#008B00', '#ffffff'] },
      \ 'm_insert_1':  { 'gui': ['#BFE2BF', '#008B00'] },
      \ 'm_insert_2':  { 'gui': ['#3FA83F', '#ffffff'] },
      \ 'm_insert_3':  { 'gui': ['#008B00', '#ffffff'] },
      \ 'm_visual':    { 'gui': ['#8b6508', '#ffffff'] },
      \ 'm_visual_1':  { 'gui': ['#E6CA85', '#8b6508'] },
      \ 'm_visual_2':  { 'gui': ['#cd950c', '#ffffff'] },
      \ 'm_visual_3':  { 'gui': ['#8b6508', '#ffffff'] },
      \ 'm_replace':   { 'gui': ['#8B3A62', '#ffffff'] },
      \ 'm_replace_1': { 'gui': ['#E2CDD7', '#8B3A62'] },
      \ 'm_replace_2': { 'gui': ['#A86B89', '#ffffff'] },
      \ 'm_replace_3': { 'gui': ['#8B3A62', '#ffffff'] },
      \ 'm_command':   { 'gui': ['#8B7355', '#ffffff'] },
      \ 'm_command_1': { 'gui': ['#E2DCD4', '#8B7355'] },
      \ 'm_command_2': { 'gui': ['#A8967F', '#ffffff'] },
      \ 'm_command_3': { 'gui': ['#8B7355', '#ffffff'] },
      \ 'm_select':    { 'gui': ['#8B7355', '#ffffff'] },
      \ 'm_select_1':  { 'gui': ['#E2DCD4', '#8B7355'] },
      \ 'm_select_2':  { 'gui': ['#A8967F', '#ffffff'] },
      \ 'm_select_3':  { 'gui': ['#8B7355', '#ffffff'] },
      \ 'm_other':     { 'gui': ['#8B7355', '#ffffff'] },
      \ 'm_other_1':   { 'gui': ['#E2DCD4', '#8B7355'] },
      \ 'm_other_2':   { 'gui': ['#A8967F', '#ffffff'] },
      \ 'm_other_3':   { 'gui': ['#8B7355', '#ffffff'] },
      \
      \ 'inactive': {'gui': ['gray23',     'gray68'],    'cterm': [ '','','reverse'] },
      \ 'warn':     {'gui': ['OrangeRed2', 'AliceBlue'], 'cterm': [ 9,16             ] },
      \ }
function! ezbar#theme#flash#load()
  return s:theme
endfunction

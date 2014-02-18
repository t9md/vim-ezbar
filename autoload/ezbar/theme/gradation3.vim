let s:theme = {}

let s:theme.dark = {
      \ 'm_normal': {'gui': ['#7E7EAE', '#000000']},
      \ 'm_normal_2': {'gui': ['#A9A9C9', '#000000']},
      \ 'm_insert': {'gui': ['#7EAE7E', '#000000']},
      \ 'm_insert_2': {'gui': ['#A9C9A9', '#000000']},
      \ 'm_visual': {'gui': ['#FFAE7E', '#000000']},
      \ 'm_visual_2': {'gui': ['#FFC9A9', '#000000']},
      \ 'm_replace': {'gui': ['#FFAE7E', '#000000']},
      \ 'm_replace_2': {'gui': ['#FFC9A9', '#000000']},
      \ 'm_command': {'gui': ['#7EC27E', '#000000']},
      \ 'm_command_2': {'gui': ['#A9D6A9', '#000000']},
      \ 'm_select': {'gui': ['#7EC27E', '#000000']},
      \ 'm_select_2': {'gui': ['#A9D6A9', '#000000']},
      \ 'm_other': {'gui': ['#7EC27E', '#000000']},
      \ 'm_other_2': {'gui': ['#A9D6A9', '#000000']},
      \
      \ 'inactive': {'gui': ['gray23',     'gray68'],    'cterm': [ '','','reverse'] },
      \ 'warn':     {'gui': ['OrangeRed2', 'AliceBlue'], 'cterm': [ 9,16             ] },
      \ '_3':   {'gui': ['gray10', ''],'cterm':['gray', '']   },
      \ }
function! ezbar#theme#gradation3#load()
  return s:theme
endfunction

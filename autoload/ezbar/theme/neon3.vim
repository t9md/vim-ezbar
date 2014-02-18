let s:theme = {}
let s:theme.dark = {
       \'m_normal':    { 'gui': ['#000000', '#ab82ff'], 'cterm': [ 0, 39 ] },
      \ 'm_normal_1':  { 'gui': ['#000000', '#ab82ff'], 'cterm': [ 0, 39 ] },
      \ 'm_normal_2':  { 'gui': ['#000000', '#ab82ff'], 'cterm': [ 0, 39 ] },
      \ 'm_normal_3':  { 'gui': ['#000000', '#ab82ff'], 'cterm': [ 0, 39 ] },
      \ 'm_insert':    { 'gui': ['#000000', '#7fff00'], 'cterm': [ 0,  82 ] },
      \ 'm_insert_1':  { 'gui': ['#000000', '#7fff00'], 'cterm': [ 0,  82 ] },
      \ 'm_insert_2':  { 'gui': ['#000000', '#7fff00'], 'cterm': [ 0,  82 ] },
      \ 'm_insert_3':  { 'gui': ['#000000', '#7fff00'], 'cterm': [ 0,  82 ] },
      \ 'm_visual':    { 'gui': ['#000000', '#ffb90f'], 'cterm': [ 0, 172 ] },
      \ 'm_visual_1':  { 'gui': ['#000000', '#ffb90f'], 'cterm': [ 0, 172 ] },
      \ 'm_visual_2':  { 'gui': ['#000000', '#ffb90f'], 'cterm': [ 0, 172 ] },
      \ 'm_visual_3':  { 'gui': ['#000000', '#ffb90f'], 'cterm': [ 0, 172 ] },
      \ 'm_replace':   { 'gui': ['#000000', '#ff1493'], 'cterm': [ 0, 126 ] },
      \ 'm_replace_1': { 'gui': ['#000000', '#ff1493'], 'cterm': [ 0, 126 ] },
      \ 'm_replace_2': { 'gui': ['#000000', '#ff1493'], 'cterm': [ 0, 126 ] },
      \ 'm_replace_3': { 'gui': ['#000000', '#ff1493'], 'cterm': [ 0, 126 ] },
      \ 'm_command':   { 'gui': ['#000000', '#54AE54'], 'cterm': [ 0,  34 ] },
      \ 'm_command_1': { 'gui': ['#000000', '#54AE54'], 'cterm': [ 0,  34 ] },
      \ 'm_command_2': { 'gui': ['#000000', '#54AE54'], 'cterm': [ 0,  34 ] },
      \ 'm_command_3': { 'gui': ['#000000', '#54AE54'], 'cterm': [ 0,  34 ] },
      \ 'm_select':    { 'gui': ['#000000', '#54AE54'], 'cterm': [ 0,  34 ] },
      \ 'm_select_1':  { 'gui': ['#000000', '#54AE54'], 'cterm': [ 0,  34 ] },
      \ 'm_select_2':  { 'gui': ['#000000', '#54AE54'], 'cterm': [ 0,  34 ] },
      \ 'm_select_3':  { 'gui': ['#000000', '#54AE54'], 'cterm': [ 0,  34 ] },
      \ 'm_other':     { 'gui': ['#000000', '#54AE54'], 'cterm': [ 0,  34 ] },
      \ 'm_other_1':   { 'gui': ['#000000', '#54AE54'], 'cterm': [ 0,  34 ] },
      \ 'm_other_2':   { 'gui': ['#000000', '#54AE54'], 'cterm': [ 0,  34 ] },
      \ 'm_other_3':   { 'gui': ['#000000', '#54AE54'], 'cterm': [ 0,  34 ] },
      \
      \ 'inactive': {'gui': ['gray23', 'gray68'], 'cterm': [ 235, 246] },
      \ 'warn':     {'gui': ['#000000', '#ff0000'], 'cterm': [ 0, 196 ] },
      \ }
function! ezbar#theme#neon3#load()
  return s:theme
endfunction

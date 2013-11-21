let c = {} | let s:colors = c
let c.EasyStatusline00 = "ctermfg=236 ctermbg=103 guifg=#30302c guibg=#8197bf"
let c.EasyStatusline01 = "ctermfg=103 ctermbg=239 guifg=#8197bf guibg=#4e4e43"
let c.EasyStatusline02 = "ctermfg=103 ctermbg=236 guifg=#8197bf guibg=#30302c"
let c.EasyStatusline03 = "ctermfg=253 ctermbg=239 guifg=#e8e8d3 guibg=#4e4e43"
let c.EasyStatusline04 = "ctermfg=239 ctermbg=236 guifg=#4e4e43 guibg=#30302c"
let c.EasyStatusline05 = "ctermfg=239 ctermbg=236 guifg=#4e4e43 guibg=#30302c"
let c.EasyStatusline06 = "ctermfg=236 ctermbg=236 guifg=#30302c guibg=#30302c"
let c.EasyStatusline07 = "ctermfg=253 ctermbg=236 guifg=#e8e8d3 guibg=#30302c"
let c.EasyStatusline08 = "ctermfg=236 ctermbg=103 guifg=#30302c guibg=#8197bf"
let c.EasyStatusline09 = "ctermfg=236 ctermbg=239 guifg=#30302c guibg=#4e4e43"
let c.EasyStatusline10 = "ctermfg=236 ctermbg=236 guifg=#30302c guibg=#30302c"
let c.EasyStatusline11 = "ctermfg=236 ctermbg=236 guifg=#30302c guibg=#30302c"
let c.EasyStatusline12 = "ctermfg=236 ctermbg=107 guifg=#30302c guibg=#99ad6a"
let c.EasyStatusline13 = "ctermfg=107 ctermbg=239 guifg=#99ad6a guibg=#4e4e43"
let c.EasyStatusline14 = "ctermfg=107 ctermbg=236 guifg=#99ad6a guibg=#30302c"
let c.EasyStatusline15 = "ctermfg=253 ctermbg=239 guifg=#e8e8d3 guibg=#4e4e43"
let c.EasyStatusline16 = "ctermfg=239 ctermbg=236 guifg=#4e4e43 guibg=#30302c"
let c.EasyStatusline17 = "ctermfg=239 ctermbg=236 guifg=#4e4e43 guibg=#30302c"
let c.EasyStatusline18 = "ctermfg=236 ctermbg=236 guifg=#30302c guibg=#30302c"
let c.EasyStatusline19 = "ctermfg=253 ctermbg=236 guifg=#e8e8d3 guibg=#30302c"
let c.EasyStatusline20 = "ctermfg=236 ctermbg=107 guifg=#30302c guibg=#99ad6a"
let c.EasyStatusline21 = "ctermfg=236 ctermbg=239 guifg=#30302c guibg=#4e4e43"
let c.EasyStatusline22 = "ctermfg=236 ctermbg=236 guifg=#30302c guibg=#30302c"
let c.EasyStatusline23 = "ctermfg=236 ctermbg=236 guifg=#30302c guibg=#30302c"
let c.EasyStatusline24 = "ctermfg=236 ctermbg=103 guifg=#30302c guibg=#8197bf"
let c.EasyStatusline25 = "ctermfg=103 ctermbg=239 guifg=#8197bf guibg=#4e4e43"
let c.EasyStatusline26 = "ctermfg=103 ctermbg=236 guifg=#8197bf guibg=#30302c"
let c.EasyStatusline27 = "ctermfg=253 ctermbg=239 guifg=#e8e8d3 guibg=#4e4e43"
let c.EasyStatusline28 = "ctermfg=239 ctermbg=236 guifg=#4e4e43 guibg=#30302c"
let c.EasyStatusline29 = "ctermfg=239 ctermbg=236 guifg=#4e4e43 guibg=#30302c"
let c.EasyStatusline30 = "ctermfg=236 ctermbg=236 guifg=#30302c guibg=#30302c"
let c.EasyStatusline31 = "ctermfg=253 ctermbg=236 guifg=#e8e8d3 guibg=#30302c"
let c.EasyStatusline31 = "ctermfg=236 ctermbg=103 guifg=#30302c guibg=#8197bf"
let c.EasyStatusline32 = "ctermfg=236 ctermbg=239 guifg=#30302c guibg=#4e4e43"
let c.EasyStatusline33 = "ctermfg=236 ctermbg=236 guifg=#30302c guibg=#30302c"
let c.EasyStatusline34 = "ctermfg=236 ctermbg=236 guifg=#30302c guibg=#30302c"
function! easy_statusline#colors#sample#set()
  for [ color, value ] in items(s:colors)
    execute 'highlight! ' . color . ' ' . value
  endfor
endfunction
function! easy_statusline#colors#sample#show()
  for color in sort(keys(s:colors))
    execute 'highlight! ' . color
  endfor
endfunction
call easy_statusline#colors#sample#set()
call easy_statusline#colors#sample#show()

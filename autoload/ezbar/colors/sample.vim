let c = {} | let s:colors = c
let c.EzBar00 = "ctermfg=236 ctermbg=103 guifg=#0306c guibg=#8197bf"
let c.EzBar01 = "ctermfg=103 ctermbg=239 guifg=#8197bf guibg=#4e4e43"
let c.EzBar02 = "ctermfg=103 ctermbg=236 guifg=#8197bf guibg=#30302c"
let c.EzBar03 = "ctermfg=253 ctermbg=239 guifg=#e8e8d3 guibg=#4e4e43"
let c.EzBar04 = "ctermfg=239 ctermbg=236 guifg=#4e4e43 guibg=#30302c"
let c.EzBar05 = "ctermfg=239 ctermbg=236 guifg=#4e4e43 guibg=#30302c"
let c.EzBar06 = "ctermfg=236 ctermbg=236 guifg=#30302c guibg=#30302c"
let c.EzBar07 = "ctermfg=253 ctermbg=236 guifg=#e8e8d3 guibg=#30302c"
let c.EzBar08 = "ctermfg=236 ctermbg=103 guifg=#30302c guibg=#8197bf"
let c.EzBar09 = "ctermfg=236 ctermbg=239 guifg=#30302c guibg=#4e4e43"
let c.EzBar10 = "ctermfg=236 ctermbg=236 guifg=#30302c guibg=#30302c"
let c.EzBar11 = "ctermfg=236 ctermbg=236 guifg=#30302c guibg=#30302c"
let c.EzBar12 = "ctermfg=236 ctermbg=107 guifg=#30302c guibg=#99ad6a"
let c.EzBar13 = "ctermfg=107 ctermbg=239 guifg=#99ad6a guibg=#4e4e43"
let c.EzBar14 = "ctermfg=107 ctermbg=236 guifg=#99ad6a guibg=#30302c"
let c.EzBar15 = "ctermfg=253 ctermbg=239 guifg=#e8e8d3 guibg=#4e4e43"
let c.EzBar16 = "ctermfg=239 ctermbg=236 guifg=#4e4e43 guibg=#30302c"
let c.EzBar17 = "ctermfg=239 ctermbg=236 guifg=#4e4e43 guibg=#30302c"
let c.EzBar18 = "ctermfg=236 ctermbg=236 guifg=#30302c guibg=#30302c"
let c.EzBar19 = "ctermfg=253 ctermbg=236 guifg=#e8e8d3 guibg=#30302c"
let c.EzBar20 = "ctermfg=236 ctermbg=107 guifg=#30302c guibg=#99ad6a"
let c.EzBar21 = "ctermfg=236 ctermbg=239 guifg=#30302c guibg=#4e4e43"
let c.EzBar22 = "ctermfg=236 ctermbg=236 guifg=#30302c guibg=#30302c"
let c.EzBar23 = "ctermfg=236 ctermbg=236 guifg=#30302c guibg=#30302c"
let c.EzBar24 = "ctermfg=236 ctermbg=103 guifg=#30302c guibg=#8197bf"
let c.EzBar25 = "ctermfg=103 ctermbg=239 guifg=#8197bf guibg=#4e4e43"
let c.EzBar26 = "ctermfg=103 ctermbg=236 guifg=#8197bf guibg=#30302c"
let c.EzBar27 = "ctermfg=253 ctermbg=239 guifg=#e8e8d3 guibg=#4e4e43"
let c.EzBar28 = "ctermfg=239 ctermbg=236 guifg=#4e4e43 guibg=#30302c"
let c.EzBar29 = "ctermfg=239 ctermbg=236 guifg=#4e4e43 guibg=#30302c"
let c.EzBar30 = "ctermfg=236 ctermbg=236 guifg=#30302c guibg=#30302c"
let c.EzBar31 = "ctermfg=253 ctermbg=236 guifg=#e8e8d3 guibg=#30302c"
let c.EzBar31 = "ctermfg=236 ctermbg=103 guifg=#30302c guibg=#8197bf"
let c.EzBar32 = "ctermfg=236 ctermbg=239 guifg=#30302c guibg=#4e4e43"
let c.EzBar33 = "ctermfg=236 ctermbg=236 guifg=#30302c guibg=#30302c"
let c.EzBar34 = "ctermfg=236 ctermbg=236 guifg=#30302c guibg=#30302c"
function! ezbar#colors#sample#set()
  for [ color, value ] in items(s:colors)
    execute 'highlight! ' . color . ' ' . value
  endfor
endfunction
function! ezbar#colors#sample#show()
  for color in sort(keys(s:colors))
    execute 'highlight! ' . color
  endfor
endfunction
call ezbar#colors#sample#set()
call ezbar#colors#sample#show()

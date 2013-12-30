if 0
  redir => CMD_OUT
  silent! highlight!
  redir END
  let g:hlnames = map(split(CMD_OUT, "\n"), 'split(v:val)[0]')
endif

let hlnames = copy(g:hlnames)
let g:hlter = ezbar#highlighter#new('Test')

echom "===START"
let start = reltime()
for hlname in hlnames
  " echo hlname '============='
  echo g:hlter.register(hlname)
endfor
" call hlter.list()
echom "===FIN"
echom reltimestr(reltime(start))
" echo len(g:hlter.colors())

"# color is defined once.
let hlter = ezbar#highlighter#new('Test')
let color1 = hlter.register( {'gui': [ 'AntiqueWhite2', 'black'] })
let color2 = hlter.register( {'gui': [ 'AntiqueWhite2', 'black'] })
echo color1
echo color2
echo hlter.register(color2)
finish

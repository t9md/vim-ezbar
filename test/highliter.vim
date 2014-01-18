if 0
  redir => CMD_OUT
  silent! highlight!
  redir END
  let g:hlnames = map(split(CMD_OUT, "\n"), 'split(v:val)[0]')
endif

" PP g:hlnames
let hlnames = copy(g:hlnames)
let g:hlter = ezbar#hlmanager#new('Test')

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
let hlter = ezbar#hlmanager#new('Test')
let color1 = hlter.register( {'gui': [ 'AntiqueWhite2', 'black'] })
let color2 = hlter.register( {'gui': [ 'AntiqueWhite2', 'black'] })
echo color1
echo color2
echo g:hlter.register(color2)
finish

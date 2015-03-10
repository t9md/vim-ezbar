" if 0
  " redir => CMD_OUT
  " silent! highlight!
  " redir END
  " let g:hlnames = map(split(CMD_OUT, "\n"), 'split(v:val)[0]')
" endif

" " PP g:hlnames
" let hlnames = copy(g:hlnames)
" let g:hlter = ezbar#hlmanager#new('Test')

" echom "===START"
" let start = reltime()
" for hlname in hlnames
  " " echo hlname '============='
  " echo g:hlter.register(hlname)
" endfor
" " call hlter.list()
" echom "===FIN"
" echom reltimestr(reltime(start))
" echo len(g:hlter.colors())

"# color is defined once.
" let g:hlter = ezbar#hlmanager#new('Test')
" let s:char = g:hlter.capture("Character")
" let s:constant = g:hlter.capture("Constant")
" echo g:hlter.convert("Constant")
" echo s:char ==# s:constant
" echo PP(g:hlter)
" echo g:hlter.capture("Comment")
" hi Constant
" hi Character
" echo g:hlter.capture("Character")
" finish
" let g:hlter = ezbar#hlmanager#new('Test')
function! s:Test()
  let spec = {'gui': ['SeaGreen',    'white', 'bold'], 'cterm': [ 10, 16 ] }
  let spec = {'gui': ['SeaGreen',    'white', 'bold'], 'cterm': [ 10, 16 ] }
  let mgr = ezbar#hlmanager#new('Test')
  let R = mgr.hl_defstr(spec)
  echo mgr.convert("Constant")
  " return PP(R)
endfunction
echo s:Test()
finish
let 

call g:hlter.hl_spec()
let color1 = g:hlter.register( {'gui': [ 'AntiqueWhite2', 'black'] })
let color2 = g:hlter.register( {'gui': [ 'AntiqueWhite2', 'black'] })
echo color1
echo color2
" echo g:hlter.register(color2)
finish

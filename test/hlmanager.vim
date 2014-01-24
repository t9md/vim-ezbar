let s:test = {}
function! s:test.test()
  let mgr = ezbar#hlmanager#new('Test')
  call mgr.register( {'gui': [ 'AntiqueWhite2', 'black'] })
  call mgr.register( {'gui': [ 'AntiqueWhite2', 'black'] })
  call mgr.register('Test000')
  " echo mgr.register('Type')
  call mgr.register('Identifier')
  call mgr.register('Function')
  " echo mgr.convert('Type')
  " echo mgr.convert_full('Identifier')
  " echo mgr.register('Type')
  echo PP(mgr._store)
  echo PP(mgr._color2name)

  call mgr.refresh()

  echo PP(mgr._store)
  echo PP(mgr._color2name)
  " echo mgr.colors()
  " echo mgr.reset()
  " echo color1
  " echo color2
  " echo mgr.register('Type')
  " echo mgr.register('Type')
endfunction

call s:test.test()

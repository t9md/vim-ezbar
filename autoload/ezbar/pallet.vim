function! ezbar#pallet#compact() "{{{1
  let colors = copy(ezbar#rgb_names())
  let width = 80
  let R = []

  new
  setlocal buftype=nofile bufhidden=hide noswapfile

  while !empty(colors)
    let s = ''
    while 1
      if empty(colors) | break | endif

      let color = remove(colors, 0)
      let color_s = ' ' . color . ' '
      if len( s . color_s) > width
        call insert(colors, color, 0)
        break
      else
        let s .= color_s
      endif
      execute 'highlight color_'.color.' guifg=black guibg='.color
      call matchadd('color_'. color , color_s , -1)
    endwhile
    if !empty(s)
      call add(R, s)
    endif
  endwhile
  call setline(1, R)
endfunction

function! ezbar#pallet#full() "{{{1
  new
  setlocal buftype=nofile bufhidden=hide noswapfile

  let lines = readfile(expand('$VIMRUNTIME/rgb.txt'))
  call filter(lines, 'v:val =~# ''^\s*\d''')
  call filter(lines, 'len(split(v:val)) is 4')
  let R = []
  for line in lines
    let [r, g, b, name] = split(line)
    let rgb = printf('%02x%02x%02x', r, g, b)
    let cmd_bg = 'highlight color_'.rgb.' guifg=black guibg=#'.rgb
    let cmd_fg = 'highlight color_'.rgb.'_fg guifg=#'.rgb.' guibg=NONE'
    execute cmd_bg
    execute cmd_fg
    call matchadd('color_'.rgb, '\<'.name.'\>', -1)
    call matchadd('color_'.rgb.'_fg', ' \{2,}| \zs\<'.name.'\>', -1)
    call add(R, printf('#%s | %-20s | %-20s', rgb, name, name))
  endfor
  call setline(1, R)
endfunction

function! ezbar#pallet#rgbs() "{{{1
  function! Colors()
    let base = range(0, 255, 16)
    let COLOR = []
    for R in copy(base)
      for G in copy(base)
        for B in copy(base)
          call add(COLOR, printf('#%02x%02x%02x', R, G, B))
        endfor
      endfor
    endfor
    return COLOR
  endfunction

  let hl = ezbar#hlmanager()
  let fg = '#fafafa'
  let R = []
  let matchadd_todo = {}
  for [bg, color_name] in map(Colors(),'
        \ [ v:val, hl.register({ "gui": [ v:val, fg ] }) ]
        \ ')
    call add(R, bg)
    let matchadd_todo[bg] = color_name
  endfor
  new
  setlocal buftype=nofile bufhidden=hide noswapfile
  let last = []
  while !empty(R)
    call add(last, join(remove(R, 0, min([10, len(R) - 1]) ), ' '))
  endwhile
  call setline(1, last)
  call clearmatches()
  for [word, color] in items(matchadd_todo)
    call matchadd(color, word)
  endfor
endfunction
" vim: foldmethod=marker

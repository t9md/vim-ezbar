function! s:open_tmp_buffer() "{{{
  new
  setlocal buftype=nofile bufhidden=hide noswapfile
endfunction

function! ezbar#pallet#compact() "{{{1
  let colors = ezbar#color_names()
  let width = 80
  let R = []

  call s:open_tmp_buffer()

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
  let colors      = ezbar#color_names()
  let colors_dict = ezbar#color_name2rgb()
  call s:open_tmp_buffer()

  let R = []
  for color in colors
    let rgb = colors_dict[color]
    let cmd_bg = 'highlight color_'.rgb.' guifg=black guibg=#'.rgb
    let cmd_fg = 'highlight color_'.rgb.'_fg guifg=#'.rgb.' guibg=NONE'
    execute cmd_bg
    execute cmd_fg
    call matchadd('color_'.rgb, '\<'.color.'\>', -1)
    call matchadd('color_'.rgb.'_fg', ' \{2,}| \zs\<'.color.'\>', -1)
    call add(R, printf('%s | %-20s | %-20s', rgb, color, color))
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
  call s:open_tmp_buffer()

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
"}}}
" vim: foldmethod=marker

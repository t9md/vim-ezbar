let es = {} | let s:es = es
" %-0{minwid}.{maxwid}{item}
" %{lightline#link()}%#LightLineLeft_active_0#%( %{exists("*MyMode")?MyMode():""} %)%{(!!strlen(exists("*MyMode")?MyMode():""))*((&paste))?('|'):''}%( %{&paste?"PASTE":""} %)%#LightLineLeft_active_0_1#%#LightLineLeft_active_1#%( %R %)%{(&readonly)*((1)+(&modified||!&modifiable))?('|'):''}%( %t %)%{(1)*((&modified||!&modifiable))?('|'):''}%( %M %)%#LightLineLeft_active_1_2#%#LightLineMiddle_active#%=%#LightLineRight_active_2_3#|%#LightLineRight_active_2#%( %{&fileformat} %)%{(1)*((1))?('|'):''}%( %{strlen(&fenc)?&fenc:&enc} %)%{(1)*((1)+(1))?('|'):''}%( %{strlen(&filetype)?&filetype:"no ft"} %)%#LightLineRight_active_1_2#%#LightLineRight_active_1#%( %3p%% %)%#LightLineRight_active_0_1#%#LightLineRight_active_0#%( %3l:%-2v %)
function! es.prepare() "{{{1
  let r = []
  let default_f = easy_statusline#functions#default()
  call extend(default_f, g:easy_statusline.functions , 'force')

  for part in g:easy_statusline.layout
    if part == '__SEP__'
      call add(r, '%#Statusline# ')
      call add(r, '%=')
    else
      unlet! p
      let p = default_f[part]()
      if empty(p)
        continue
      endif
      if type(p) == type('')
        let d = { 's': p, 'c': 'Comment' }
      else
        let d = p
      endif
      call add(r, d)
    endif
  endfor
  return r
endfunction

function! es.string()
  let lis = self.prepare()
  let r = ''
  let last_color = ''
  for idx in range(len(lis))
    unlet! v
    let v = lis[idx]
    if type(v) == type({})
      let s = '%#'. v.c . '# ' . v.s
    else
      let s = v
      let last_color = ''
      let r .= s
      continue
    endif
    let next = idx + 1
    if next != len(lis) && type(lis[idx+1]) == type({})
      if v.c == lis[next].c
        let sep = ' |'
      else
        let sep = ' '
      endif
    else
      let sep = ' '
    endif
    let r .= s
    let r .= sep
    let last_color = v.c
  endfor
  return r
endfunction

function! easy_statusline#string() "{{{1
  " return '%#SmallsCurrent#%(n%) %#Normal# vim %= %l/%L %p%%'
  return s:es.string()
endfunction
echo s:es.string()

function! easy_statusline#string() "{{{1
  return s:es.string()
endfunction

function! easy_statusline#set() "{{{1
  let &statusline='%!easy_statusline#string()'
endfunction
" echo es.string()
" vim: foldmethod=marker

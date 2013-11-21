let es = {} | let s:es = es

let g:easy_statusline = {}
let g:easy_statusline.layout = [
      \ 'mode',
      \ 'filetype',
      \ 'textmanip',
      \ '__SEP__',
      \ 'line',
      \ 'percent',
      \ ]

" %{lightline#link()}%#LightLineLeft_active_0#%( %{exists("*MyMode")?MyMode():""} %)%{(!!strlen(exists("*MyMode")?MyMode():""))*((&paste))?('|'):''}%( %{&paste?"PASTE":""} %)%#LightLineLeft_active_0_1#%#LightLineLeft_active_1#%( %R %)%{(&readonly)*((1)+(&modified||!&modifiable))?('|'):''}%( %t %)%{(1)*((&modified||!&modifiable))?('|'):''}%( %M %)%#LightLineLeft_active_1_2#%#LightLineMiddle_active#%=%#LightLineRight_active_2_3#|%#LightLineRight_active_2#%( %{&fileformat} %)%{(1)*((1))?('|'):''}%( %{strlen(&fenc)?&fenc:&enc} %)%{(1)*((1)+(1))?('|'):''}%( %{strlen(&filetype)?&filetype:"no ft"} %)%#LightLineRight_active_1_2#%#LightLineRight_active_1#%( %3p%% %)%#LightLineRight_active_0_1#%#LightLineRight_active_0#%( %3l:%-2v %)
function! es.string() "{{{1
  let r = []
  let default_f = easy_statusline#functions#default()
  for part in g:easy_statusline.layout
    if part == '__SEP__'
      call add(r, '%=')
    else
      let p = default_f[part]()
      if type(p) == type({})
        let d = '%#'. p.c . '# ' . p.s
      else
        let d = '%#' . 'StatusLine' . '# ' . p
      endif
      unlet p
      call add(r, d)
    endif
  endfor
  let s = join(r, ' ')
  return s
endfunction

function! easy_statusline#string() "{{{1
  " return '%#SmallsCurrent#%(n%) %#Normal# vim %= %l/%L %p%%'
  return s:es.string()
endfunction

function! easy_statusline#set() "{{{1
  let &statusline='%!easy_statusline#string()'
endfunction
echo es.string()
command! EasyStatusLine call easy_statusline#set()
" vim: foldmethod=marker

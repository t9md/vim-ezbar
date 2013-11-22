let c = {}
function! c.load()
  let _rgb = readfile(expand("$VIMRUNTIME/rgb.txt"))
  " echo len(colors)
  let colors = []
  for color in _rgb
    if color =~# '^\s*\(\d\+\s*\)\{3}\zs\w*$'
      let color = matchstr(color, '^\s*\(\d\+\s*\)\{3}\zs\w*\ze$')
      call add(colors, color)
    endif
  endfor
  return colors
endfunction
function! c.init()
  let self.colors = self.load()
endfunction
function! c.show_colors()
  echo join(self.colors, "\n")
endfunction
call c.init()
call c.show_colors()
finish

call clearmatches()
new
setlocal buftype=nofile bufhidden=hide noswapfile
0read $VIMRUNTIME/rgb.txt
let find_color = '^\s*\(\d\+\s*\)\{3}\zs\w*$'
silent execute 'v/'.find_color.'/d'
silent g/grey/d
let namedcolors=[]
1
while search(find_color, 'W') > 0
    let w = expand('<cword>')
    call add(namedcolors, w)
endwhile

for w in namedcolors
    execute 'hi col_'.w.' guifg=black guibg='.w
    execute 'hi col_'.w.'_fg guifg='.w.' guibg=NONE'
    execute '%s/\<'.w.'\>/'.printf("%-36s%s", w, w).'/g'

    call matchadd('col_'.w, '\<'.w.'\>', -1)
    " determine second string by that with large # of spaces before it
    call matchadd('col_'.w.'_fg', ' \{10,}\<'.w.'\>', -1)
endfor
1
nohlsearch


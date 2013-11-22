" To use, save this file and type ":so %"
" Optional: First enter ":let g:rgb_fg=1" to highlight foreground only.
" Restore normal highlighting by typing ":call clearmatches()"
"
" Create a new scratch buffer:
" - Read file $VIMRUNTIME/rgb.txt
" - Delete lines where color name is not a single word (duplicates).
" - Delete "grey" lines (duplicate "gray"; there are a few more "gray").
" Add matches so each color name is highlighted in its color.
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

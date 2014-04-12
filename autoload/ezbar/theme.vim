function! ezbar#theme#list(A, L, P) "{{{1
  let themes = map(
        \ split(globpath(&rtp , 'autoload/ezbar/theme/*.vim'), "\n"),
        \ 'fnamemodify(v:val, '':t:r'')'
        \ )
  return filter(themes, 'v:val =~ ''^' . a:A . '''')
endfunction

function! ezbar#theme#load(theme) "{{{1
  return ezbar#theme#{a:theme}#load()
endfunction
"}}}
" vim: foldmethod=marker

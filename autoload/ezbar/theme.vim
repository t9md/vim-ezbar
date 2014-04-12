function! ezbar#theme#list(A, L, P) "{{{1
  return map(
        \ split(globpath(&rtp , 'autoload/ezbar/theme/*.vim'), "\n"),
        \ 'fnamemodify(v:val, '':t:r'')'
        \ )
endfunction

function! ezbar#theme#load(theme) "{{{1
  return ezbar#theme#{a:theme}#load()
endfunction
"}}}
" vim: foldmethod=marker

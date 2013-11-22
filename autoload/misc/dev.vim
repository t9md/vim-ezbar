if !empty(s:hls)
  let s:hls = split(hl, "\n")
endif
echo join(filter(copy(s:hls), "v:val !~# ' xxx links to \\| xxx cleared'"), "\n")

let h = {}
function! h.get(hlname) "{{{1
  redir => hl
  exe 'silent! highlight ' . a:hlname
  redir END
  return  substitute(hl, "\n", '', 'g')
endfunction
function! h.write_all(hlnames)
  let r = []
  for hlname in a:hlnames
    call add(r, self.get(hlname))
  endfor
  let tempfile = tempname()
  exe 'silent split ' . tempfile
  call setline(1, r)
  for n in range(1, len(r))
    let hlname = matchstr(r[n-1], '.\{-}\ze\s')
    echo hlname
    let pat = '\%' . n . 'lxxx'
    call matchadd(hlname,  pat)
  endfor
endfunction
echo h.write_all(['Visual', 'VimParenSep'])

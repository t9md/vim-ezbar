# DON't USE THIS
Very experimental stage.
NO CUI mode color support.

# What's this?
statusline configuration helper for minimalist.

# Feature
* no fancy colorscheme
* simple design, easy to configure for vim-scripter(advanced user), no fail-safe guared for begginer
* dynamically configure color based on condition.
* all statusline component(part) is implemented as dictionary function.
* no precedence to predefined parts, so it's up to you how organize your statusline.

# CONCEPT
* user configuration is stored under `g:ezbar` dictionary
* part shown is controlled with `g:ezbar.active.layout`, `g:ezbar.inactive.layout` array.
  ```Vim
  " active window's statusline
  let g:ezbar.active.layout = [
        \ 'mode',
        \ 'filetype',
        \ '__SEP__',
        \ 'encoding',
        \ 'percent',
        \ ]
  " inactive window's statusline
  let g:ezbar.inactive.layout = [
        \ 'filetype',
        \ '__SEP__',
        \ 'encoding',
        \ 'percent',
        \ ]
  ```

* Layout consists of `part`. Each part is mapped to result of `g:ezbar.parts[{part}]()`.
  ```Vim
  let g:ezbar.active.layout = [
        \ 'mode',        <-- g:ezbar.parts.mode()
        \ 'filetype',    <-- g:ezbar.parts.filetype()
        \ '__SEP__',     <-- g:ezbar.parts.__SEP__()
        \ 'encoding',    <-- g:ezbar.parts.encoding()
        \ 'percent',     <-- g:ezbar.parts.percent()
        \ ]
  ```

* So all you have to do is write your own function and use that function in `layout`. That's it!
  ```Vim
  let g:ezbar.active.layout = [
        \ 'my_encoding', <-- g:ezbar.parts.my_encoding()
        \ ]
  function! g:ezbar.parts.my_encoding()
    return &encoding
  endfunction
  ```

* But its' tiresome to write all configuration by your self?  
Merge parts other user provide and add a little portion
  ```Vim
  let u = {}
  function! u.my_encoding()
    return &encoding
  endfunction
  let g:ezbar.parts = extend(ezbar#parts#default#new(), u)
  unlet u
  ```

* each part function should return simple string or dictionary
  ```Vim
  " return simple string
  function! u.my_encoding()
    return &encoding
  endfunction

  " return dictionary, change color when git branch is not 'master'
  function! u.fugitive() "{{{1
    let s = fugitive#head()
    if empty(s)
      return ''
    endif
    return { 's' : s, 'c': s == 'master'
          \ ?  ['gray18', 'gray61']
          \ :  ['red4', 'gray61']
          \ }
  endfunction
  let g:ezbar.parts = extend(ezbar#parts#default#new(), u)
  unlet u
  ```
Empty string or Dictionary or Dictionary for 's' is empty will not shown to statusline.

* as you see in above example you can set color directly
  ```Vim
  " directly specify color ['guibg', 'guifg' ]
  { 's' : "foo", 'c': ['gray18', 'gray61'] }

  " use predefined color
  { 's' : "foo", 'c': 'Statement' }

  " optional color `'ac'` for active window, and `'ic'` inactive window.
  " **color precedence
  "   active:   'ac' => 'c' => g:ezbar.active.default_color
  "   inactive: 'ic' => 'c' => g:ezbar.inactive.default_color
  { 's': 'bar', 'ac' : ['gray40', 'gray95'] }
  ```

* To check color available  
`:help rgb.txt`
`:edit misc/colortest/compact.vim` then `%so`  
`:so misc/colortest/full.vim` then `%so`  

* Also you can use `self.__is_active` in each `part` to know whether here is active window or not.
```Vim
  function! f.percent() "{{{1
    let s  = '%3p%%'
    if g:ezbar.parts.__is_active
      return { 's': s, 'c' : ['gray40', 'gray95'] }
    else
      return s
    endif
  endfunction
```

# Configuration Sample
[ExampleFile](https://github.com/t9md/vim-ezbar/tree/master/misc/config_sample)

While preparing configuration, following command might help.
`:EzBarUpdate` update current statusline for active window.  
`:EzBarDisable` disable and delete autocmd  
`:EzBarSet` set all window's statusline  
`:'<,'>EzBarColorPreview` set color to visually selected range for preview.  
`:echo ezbar#string('active')` or `:echo ezbar#string('inactive')`  

* Basic
  ```Vim
  let g:ezbar = {}
  let g:ezbar.active = {}
  let s:bg = 'gray25'
  let g:ezbar.active.default_color = [ s:bg, 'gray61']
  let g:ezbar.active.sep_color = [ 'gray22', 'gray61']
  let g:ezbar.inactive = {}
  let g:ezbar.inactive.default_color = [ 'gray22', 'gray57' ]
  let g:ezbar.inactive.sep_color = [ 'gray23', 'gray61']
  let g:ezbar.active.layout = [
        \ 'mode',
        \ 'textmanip',
        \ 'smalls',
        \ 'modified',
        \ 'filetype',
        \ 'fugitive',
        \ '__SEP__',
        \ 'encoding',
        \ 'percent',
        \ 'line_col',
        \ ]
  let g:ezbar.inactive.layout = [
        \ 'modified',
        \ 'filename',
        \ '__SEP__',
        \ 'encoding',
        \ 'percent',
        \ ]

  let u = {}
  function! u.textmanip() "{{{1
    let s = toupper(g:textmanip_current_mode[0])
    return { 's' : s, 'c': s == 'R'
          \ ?  [ s:bg, 'HotPink1']
          \ :  [ s:bg, 'PaleGreen1'] }
  endfunction
  function! u.smalls() "{{{1
    let s = toupper(g:smalls_current_mode[0])
    if empty(s)
      return ''
    endif
    return { 's' : 'smalls-' . s, 'c':
          \ s == 'E' ? 'SmallsCurrent' : 'Function' }
  endfunction

  function! u.fugitive() "{{{1
    let s = fugitive#head()
    if empty(s)
      return ''
    endif
    return { 's' : s, 'c': s == 'master'
          \ ?  ['gray18', 'gray61']
          \ :  ['red4', 'gray61']
          \ }
          " \ ?  ['red4', 'gray61']
  endfunction
  " function! u._filter(layout) "{{{1
    " echo len(a:layout)
  " endfunction

  let g:ezbar.parts = extend(ezbar#parts#default#new(), u)
  unlet u
  ```

* Advanced
  ```Vim
  let s:bg = 'gray25'

  let g:ezbar = {}
  let g:ezbar.active = {}                      
  let g:ezbar.active.default_color = [ s:bg, 'gray61']
  let g:ezbar.active.sep_color = [ 'gray30', 'gray61']
  let g:ezbar.inactive = {}
  let g:ezbar.inactive.default_color = [ 'gray18', 'gray57' ]
  let g:ezbar.inactive.sep_color = [ 'gray23', 'gray61']
  let g:ezbar.active.layout = [
        \ 'mode',
        \ 'textmanip',
        \ 'smalls',
        \ 'modified',
        \ 'filetype',
        \ 'fugitive',
        \ '__SEP__',
        \ 'encoding',
        \ 'percent',
        \ 'line_col',
        \ ]
  let g:ezbar.inactive.layout = [
        \ 'modified',
        \ 'filename',
        \ '__SEP__',
        \ 'encoding',
        \ 'percent',
        \ ]

  let u = {}
  function! u.textmanip() "{{{1
    return toupper(g:textmanip_current_mode[0])
  endfunction
  function! u.smalls() "{{{1
    let self.__smalls_active = 0
    let s = toupper(g:smalls_current_mode[0])
    if empty(s)
      return ''
    endif
    let self.__smalls_active = 1
    let color = s == 'E' ? 'SmallsCurrent' : 'SmallsCandidate'
    return { 's' : 's', 'c': color }
  endfunction

  function! u.fugitive() "{{{1
    return fugitive#head()
  endfunction

  " filter is special function, if `g:ezbar.parts._filter` is function.
  " ezbar call this function with normalized layout as argument.
  function! u._filter(layout) "{{{1
    if !self.__smalls_active && self.__is_active
      " fill statusline when smalls is active
      return filter(a:layout, 'v:val.name == "smalls"')
    endif

    let r =  []
    " you can decorate color here instead of in each part function.
    for part in a:layout
      if part.name == 'fugitive'
        let part.c = part.s == 'master' ?  ['gray18', 'gray61'] : ['red4', 'gray61']
      elseif part.name == 'textmanip'
        let part.c = part.s == 'R' ? [ s:bg, 'HotPink1'] :  [ s:bg, 'PaleGreen1']
      endif
      call add(r, part)
    endfor
    return r
  endfunction

  let g:ezbar.parts = extend(ezbar#parts#default#new(), u)
  unlet u
  ```

# DON't USE THIS
Very experimental stage.

# What's this?
statusline configuration helper for minimalist.

# Feature
* no fancy colorscheme
* simple design, easy to configure for vim-scripter(advanced user), no fail-safe guared for begginer
* dynamically configure color based on condition.
* all statusline component(part) is implemented as dictionary function.
* no precedence to predefined parts, so it's up to you how organize your statusline.

# Screen Capture
* Change color when git branch is not master  
![ConditionalColor-1](https://raw.github.com/t9md/t9md/master/img/ezbar/ezbar_conditional_color1.png)  
![ConditionalColor-2](https://raw.github.com/t9md/t9md/master/img/ezbar/ezbar_conditional_color2.png)  

* Hide other statusline part when specific plugin active  
![Fill-1](https://raw.github.com/t9md/t9md/master/img/ezbar/ezbar_fill1.png)  
![Fill-2](https://raw.github.com/t9md/t9md/master/img/ezbar/ezbar_fill2.png)  

# CONCEPT
* user configuration is stored under `g:ezbar` dictionary
* part shown is controlled with `g:ezbar.active`, `g:ezbar.inactive` array.
  ```Vim
  " active window's statusline
  let g:ezbar.active = [
        \ 'mode',
        \ 'filetype',
        \ 'encoding',
        \ 'percent',
        \ ]
  " inactive window's statusline
  let g:ezbar.inactive = [
        \ 'filetype',
        \ 'encoding',
        \ 'percent',
        \ ]
  ```

* Layout consists of `part`. Each part is mapped to result of `g:ezbar.parts[{part}]()`.
  ```Vim
  let g:ezbar.active = [
        \ 'mode',        <-- g:ezbar.parts.mode()
        \ 'filetype',    <-- g:ezbar.parts.filetype()
        \ 'encoding',    <-- g:ezbar.parts.encoding()
        \ 'percent',     <-- g:ezbar.parts.percent()
        \ ]
  ```

* So all you have to do is write your own function and use that function in `active` or `inactive` array. That's it!
  ```Vim
  let g:ezbar.active = [
        \ 'my_encoding', <-- g:ezbar.parts.my_encoding()
        \ ]
  function! g:ezbar.parts.my_encoding()
    return &encoding
  endfunction
  ```

* But sometime, its' tiresome to write all configuration by your self?  
Merge parts other user provide with a portion you added.
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
          \ ?  { 'gui': ['gray18', 'gray61'] }
          \ :  { 'gui': ['red4', 'gray61'] }
          \ }
  endfunction
  let g:ezbar.parts = extend(ezbar#parts#default#new(), u)
  unlet u
  ```
Empty string or Dictionary or Dictionary for 's' is empty will not shown to statusline.

* as you see in above example you can set color directly
color is expressed as dictionary with following format
  ```Vim
  {'gui': [guibg, guifg, gui], 'cterm': [ctermbg, ctermbg, cterm] }
  ```

if you want to set only gui bold, you can let other part empty like bellow.

  ```Vim
  {'gui': ['', '', 'bold'] }
  ```

here are small example of how to use color

  ```Vim
  " directly specify color
  { 's' : "foo", 'c': {'gui': ['gray18', 'gray61'] }}

  " use predefined color( not managed by ezbar highlighter)
  { 's' : "foo", 'c': 'Statement' }

  " optional color `'ac'` for active window, and `'ic'` inactive window.
  " **color precedence
  "   active:   'ac' => 'c' => g:ezbar.active.default_color
  "   inactive: 'ic' => 'c' => g:ezbar.inactive.default_color
  { 's': 'bar', 'ac' : {'gui': ['gray40', 'gray95'] }}
  ```

* To check color available  
`:help rgb.txt`
`:edit misc/colortest/compact.vim` then `%so`  
`:so misc/colortest/full.vim` then `%so`  

* Also you can use `self.__is_active` in each `part` to know whether here is active window or not.
  ```Vim
  function! f.percent() "{{{1
    let s  = '%3p%%'
    if self.__is_active
      return { 's': s, 'c' : { 'gui': ['gray40', 'gray95'] } }
    else
      return s
    endif
  endfunction
  ```
* Special treatment in layout array.
In `g:ezbar.active` or `g:ezbar.inactive` array.
If member is `string`. it mapped to parts function, otherwise some special handling.

  ```Vim
  let g:ezbar.active = [
        \ { 'chg_color': {'gui': ['gray18', 'gray57']}}, <-- change default color
        \ 'mode',
        \ 'filetype',
        \ { 'chg_color': {'gui': ['gray18', 'red']}}, <-- can use multiple time
        \ 'fugitive',
        \ { '__SEP__': {'gui':[ 'gray22', 'gray61']}}, <-- separator with color.
        \ 'encoding',
        \ 'line_col',
        \ ]
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
  let s:bg = 'gray25'
  let s:c = {
        \ 'act_L':         { 'gui': [ s:bg,     'gray61']     },
        \ 'act_SEP':       { 'gui': [ 'gray22', 'gray61']     },
        \ 'inact_L':       { 'gui': [ 'gray22', 'gray57']    },
        \ 'inact_SEP':     { 'gui': [ 'gray23', 'gray61']     },
        \ 'plug_STANDOUT': { 'gui': [ s:bg,     'HotPink1']   },
        \ 'plug_NORMAL':   { 'gui': [ s:bg,     'PaleGreen1'] },
        \ 'plug_WARNING':  { 'gui': ['red4',    'gray61']     },
        \ }


  let g:ezbar = {}
  let g:ezbar.active = [
        \ { 'chg_color': s:c.act_L} ,
        \ 'mode',
        \ 'textmanip',
        \ 'smalls',
        \ 'modified',
        \ 'filetype',
        \ 'fugitive',
        \ { '__SEP__': s:c.act_SEP },
        \ 'encoding',
        \ 'percent',
        \ 'line_col',
        \ ]
  let g:ezbar.inactive = [
        \ {'chg_color': s:c.inact_L },
        \ 'modified',
        \ 'filename',
        \ { '__SEP__': s:c.inact_SEP },
        \ 'encoding',
        \ 'percent',
        \ ]

  let s:u = {}
  function! s:u.textmanip() "{{{1
    let s = toupper(g:textmanip_current_mode[0])
    return { 's' : s, 'c': s == 'R'
          \ ? s:c.plug_STANDOUT
          \ : s:c.plug_NORMAL }
  endfunction

  function! s:u.smalls() "{{{1
    let s = toupper(g:smalls_current_mode[0])
    if empty(s)
      return ''
    endif
    return { 's' : 'smalls-' . s, 'c':
          \ s == 'E' ? 'SmallsCurrent' : 'Function' }
  endfunction

  function! s:u.fugitive() "{{{1
    let s = fugitive#head()
    if empty(s)
      return ''
    endif
    return { 's' : s, 'c': (s != 'master') ? s:c.plug_WARNING : '' }
  endfunction

  let g:ezbar.parts = extend(ezbar#parts#default#new(), s:u)
  unlet! s:u

  " echo ezbar#string()
  " nnoremap <F9> :<C-u>EzBarUpdate<CR>

  ```

* Advanced
  ```Vim
  let s:bg = 'gray25'

  function! s:GUI(...)
    return { 'gui': a:000 }
  endfunction

  let g:ezbar = {}
  let g:ezbar.active = [
        \ { 'chg_color': s:GUI( s:bg, 'gray61') },
        \ 'mode',
        \ 'textmanip',
        \ 'smalls',
        \ 'modified',
        \ 'filetype',
        \ 'fugitive',
        \ { '__SEP__': s:GUI('gray30', 'gray61') },
        \ 'encoding',
        \ 'percent',
        \ 'line_col',
        \ ]
  let g:ezbar.inactive = [
        \ { 'chg_color': s:GUI('gray18', 'gray57')},
        \ 'modified',
        \ 'filename',
        \ { '__SEP__': s:GUI('gray23', 'gray61') },
        \ 'encoding',
        \ 'percent',
        \ ]

  let s:u = {}
  function! s:u.textmanip() "{{{1
    return toupper(g:textmanip_current_mode[0])
  endfunction
  function! s:u.smalls() "{{{1
    let s = toupper(g:smalls_current_mode[0])
    if empty(s)
      return ''
    endif
    let self.__smalls_active = 1
    let color = s == 'E' ? 'SmallsCurrent' : 'SmallsCandidate'
    return { 's' : 's', 'c': color }
  endfunction

  function! s:u.fugitive() "{{{1
    return fugitive#head()
  endfunction

  " `_init()` is special function, if `g:ezbar.parts._init` is function.
  " use this to define some field to store state.
  function! s:u._init() "{{{1
    let self.__smalls_active = 0
  endfunction

  " `_filter()` is special function, if `g:ezbar.parts._filter` is function.
  " ezbar call this function with normalized layout as argument.
  function! s:u._filter(layout) "{{{1
    if self.__smalls_active && self.__is_active
      " fill statusline when smalls is active
      return filter(a:layout, 'v:val.name == "smalls"')
    endif

    let r =  []
    " you can decorate color here instead of in each part function.
    for part in a:layout
      if part.name == 'fugitive'
        let part.c = part.s == 'master' ? s:GUI('gray18', 'gray61') : s:GUI('red4', 'gray61')
      elseif part.name == 'textmanip'
        let part.c = part.s == 'R' ? s:GUI( s:bg, 'HotPink1') : s:GUI( s:bg, 'PaleGreen1')
      endif
      call add(r, part)
    endfor
    return r
  endfunction

  let g:ezbar.parts = extend(ezbar#parts#default#new(), s:u)
  unlet s:u
  delfunction s:GUI
  ```

[日本語はこちら](https://github.com/t9md/vim-ezbar/blob/master/README-JP.md)

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

* Layout consists of `part`. Each part is mapped to result of `g:ezbar.parts[{part}](n)`.
each parts function take one argment, it is windownumber(`n`) of each statusline reside.

  ```Vim
  let g:ezbar.active = [
        \ 'mode',        <-- g:ezbar.parts.mode(n)
        \ 'filetype',    <-- g:ezbar.parts.filetype(n)
        \ 'encoding',    <-- g:ezbar.parts.encoding(n)
        \ 'percent',     <-- g:ezbar.parts.percent(n)
        \ ]
  ```

* So all you have to do is write your own function and use that function in `active` or `inactive` array. That's it!
  ```Vim
  let g:ezbar.active = [
        \ 'my_encoding', <-- g:ezbar.parts.my_encoding(n)
        \ ]
  function! g:ezbar.parts.my_encoding(n)
    return getwinvar(a:n, '&encoding')
  endfunction
  ```
NOTE: for variable that is vary from each buffer or windows, you need to use `getwinvar()`, otherwise all statusline parts result in showing value of active windows variable, lets say if you define above `my_encoding()` like bellow
  ```Vim
  function! g:ezbar.parts.my_encoding(n)
    return &encoding
  endfunction
  ```
Result in all statusline shows active windows `&encoding` which is not what you wanted.

* But sometime, its' tiresome to write all configuration by your self?  
Merge parts other user provide with a portion you added.
  ```Vim
  let u = {}
  function! u.my_encoding(n)
    return getwinvar(a:n, '&encoding')
  endfunction
  let g:ezbar.parts = extend(ezbar#parts#default#new(), u)
  unlet u
  ```

* each part function should return simple string or dictionary

  ```Vim
  " return simple string
  function! u.my_encoding(n)
    return getwinvar(a:n, '&encoding')
  endfunction

  " return dictionary, change color when git branch is not 'master'
  function! u.fugitive(n) "{{{1
    let s = fugitive#head()
    if empty(s)
      return ''
    endif
    return { 's' : s,
          \ 'c': s !=# 'master' ? { 'gui': ['red4', 'gray61'] } : '' }
  endfunction

  let g:ezbar.parts = extend(ezbar#parts#default#new(), u)
  unlet u
  ```

* Empty string, dictionary, List means values which `empty()` function return 1
* Dictionary for 's' key is empty

As you see in above example you can set color directly.
Color is expressed as dictionary with following form.
  ```Vim
  {'gui': [guibg, guifg, gui], 'cterm': [ctermbg, ctermfg, cterm] }
  ```

You can omit color that you dont use.

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
  "   active:   'ac' => 'c' => default_color
  "   inactive: 'ic' => 'c' => default_color
  { 's': 'bar', 'ac' : {'gui': ['gray40', 'gray95'] }}
  ```

For default_color, you can change default_color within layout whenever you want, by using following special part.

```Vim
  { 'chg_color': {'gui': [ s:bg, 'gray61'] }}
```

* What color is available?
`:help rgb.txt`
`:edit misc/colortest/compact.vim` then `%so`  
`:so misc/colortest/full.vim` then `%so`  

* Also you can use `self.__is_active` in each `part` to know whether here is active window or not.
  ```Vim
  function! f.percent(n) "{{{1
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
        \ { 'chg_color': {'gui': ['gray18', 'gray57']}}, <-- set default color
        \ 'mode',
        \ 'filetype',
        \ { 'chg_color': {'gui': ['gray18', 'red']}}, <-- can use multiple time
        \ 'fugitive',
        \ { '__SEP__': {'gui':[ 'gray22', 'gray61']}}, <-- separator with color.
        \ 'encoding',
        \ 'line_col',
        \ ]
  ```

# Limitation for part function
Each part function is evaluated in active window's context.  
Thats why you need `getwinvar()` for part which part you want to show in inactive window.
For the variable not window or buffer local, using `getwinvar()` could not be workaround.

This is `ezbar` and Vim limitaion.
* `ezbar` limitation
`&statusline` provide `%{}` expression where inner expression is evaluated in each window's context.
But, To change color based on value, color need to be decided at the timing of `&statusline` string is generated. So, using `%{}` is not option for `ezbar`.

* Vim's limitation
`statusline` is evaluated at sandbox environment, which not support moving window in the expression used in `&statusline`.
This is for security, but this enforcement limit ezbar to know other window's value(which could not be retrieved via `getwinvar()`) in part function.


# Configuration Sample
[ExampleFile](https://github.com/t9md/vim-ezbar/tree/master/misc/config_sample)

While preparing configuration, following command might help.
* `:EzBarUpdate` update current statusline for active window.  
* `:EzBarDisable` disable and delete autocmd  
* `:EzBarEnable` enable ezbar
* `:EzBarSet` set all window's statusline  
* `:echo ezbar#string('active')` or `:echo ezbar#string('inactive')`  

* Basic
  ```Vim

  let s:bg = 'gray25'
  let s:c = {
        \ 'L_act':    { 'gui': [ s:bg,     'gray61']     },
        \ 'L_inact':  { 'gui': [ 'gray22', 'gray57']     },
        \ 'SEP_act':  { 'gui': [ 'gray22', 'gray61']     },
        \ 'SEP_inact':{ 'gui': [ 'gray23', 'gray61']     },
        \ 'STANDOUT': { 'gui': [ s:bg,     'HotPink1']   },
        \ 'NORMAL':   { 'gui': [ s:bg,     'PaleGreen1'] },
        \ 'WARNING':  { 'gui': ['red4',    'gray61']     },
        \ }

  let g:ezbar = {}
  let g:ezbar.active = [
        \ { 'chg_color': s:c.L_act} ,
        \ 'mode',
        \ 'textmanip',
        \ 'smalls',
        \ 'modified',
        \ 'filetype',
        \ 'fugitive',
        \ { '__SEP__': s:c.SEP_act },
        \ 'encoding',
        \ 'percent',
        \ 'line_col',
        \ ]
  let g:ezbar.inactive = [
        \ {'chg_color': s:c.L_inact },
        \ 'modified',
        \ 'filename',
        \ { '__SEP__': s:c.SEP_inact },
        \ 'encoding',
        \ 'percent',
        \ ]

  let s:u = {}
  function! s:u.textmanip(_) "{{{1
    let s = toupper(g:textmanip_current_mode[0])
    return { 's' : s, 'c': s == 'R' ? s:c.STANDOUT : s:c.NORMAL }
  endfunction

  function! s:u.smalls(_) "{{{1
    let s = toupper(g:smalls_current_mode[0])
    if empty(s)
      return ''
    endif
    return { 's' : 'smalls-' . s, 'c':
          \ s == 'E' ? 'SmallsCurrent' : 'Function' }
  endfunction

  function! s:u.fugitive(_) "{{{1
    let s = fugitive#head()
    return { 's': s, 'c': s !=# 'master' ? s:c.WARNING : ''  }
  endfunction

  let g:ezbar.parts = extend(ezbar#parts#default#new(), s:u)
  unlet s:u
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

  function! s:u.textmanip(_) "{{{1
    return toupper(g:textmanip_current_mode[0])
  endfunction

  function! s:u.smalls(_) "{{{1
    let s = toupper(g:smalls_current_mode[0])
    if empty(s)
      return ''
    endif
    let self.__smalls_active = 1
    return { 's' : 's', 'c': s == 'E' ? 'SmallsCurrent' : 'SmallsCandidate' }
  endfunction

  function! s:u.fugitive(_) "{{{1
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
        let part.c = part.s == 'R' ? s:GUI(s:bg, 'HotPink1') : s:GUI(s:bg, 'PaleGreen1')
      endif
      call add(r, part)
    endfor
    return r
  endfunction

  let g:ezbar.parts = extend(ezbar#parts#default#new(), s:u)
  unlet s:u
  ```

[日本語はこちら](https://github.com/t9md/vim-ezbar/blob/master/README-JP.md)

# What's this?
Advanced, customizable statusline plugin for minimalist.

# Feature
* simple design, easy to configure for vim-scripter(advanced user)
* dynamically configure color based on condition.
* all statusline component(part) is implemented as dictionary function.
* no precedence to predefined parts, so it's up to you how organize your statusline.

# Screen Capture
* Mode aware
![normal](https://raw.github.com/t9md/t9md/master/img/ezbar/neon-normal.png)
![insert](https://raw.github.com/t9md/t9md/master/img/ezbar/neon-insert.png)
![visual](https://raw.github.com/t9md/t9md/master/img/ezbar/neon-visual.png)

* Conditional color change
In following example, if buffer is `[quickrun output]` change foreground color `green`, and if filename is begin with `tryit` use color `yellow`.
Its fully configurable.
![cond-buffer](https://raw.github.com/t9md/t9md/master/img/ezbar/cond-buffer.png)
```vim
function! s:u._filename() "{{{1
  let s = self.filename()
  if !self.__active && s =~# '\[quickrun output\]'
    return {
          \ 's' : s,
          \ 'c'  : self.__color.m_insert }
  endif

  let notify_sym = "\U2022"
  if s =~# 'tryit\.\|default\.vim\|phrase__'
    return {
          \ 's' : notify_sym . s,
          \ 'c'  : self.__.fg(self.__color._info) }
  else
    return s
  endif
endfunction
```

use red foreground color when git-branch is not `master`.
![dev-branch](https://raw.github.com/t9md/t9md/master/img/ezbar/cond-git-branch.png)
```vim
function! s:u.fugitive() "{{{1
  let s = fugitive#head()
  if s is '' | return '' | endif
  let branch_symbol = g:ezbar.symbols['branch'] . ' '
  if s ==# 'master'
    return { 's': branch_symbol . s }
  else
    return { 's': branch_symbol . s, 'c': self.__.fg(self.__color._warn) }
  endif
endfunction
```

# QuickStart

### Configure  `.vimrc`

```Vim
let g:ezbar_enable   = 1
```

Without any other configuration, ezbar use default configuration stored
in `autoload/ezbar/config/default.vim`.

### To customize.

Copy `autoload/ezbar/config/default.vim` to your configuration folder and source it in you `.vimrc`

```Vim
" for quick edit of ezbar config
nnoremap <Space>e  :<C-u>edit $EZBAR_CONFIG<CR>

let g:ezbar_enable   = 1

let $EZBAR_CONFIG = expand("~/.vim/ezbar_config.vim")
if filereadable($EZBAR_CONFIG)
  source $EZBAR_CONFIG
endif
```

## You can use following tool to customize statusline

* special variable: `__c`, `__color`, `__filetype` etc.
* hook: `__init()`, `__finish()`, `__part_missing()` etc.
* color_table: stored to g:ezbar.color dictionary.
* helper: collection of function to manupilate color

* Example:
See `autoload/ezbar/config/t9md.vim` which is my config.

* Help
See `:help ezbar`

## TIPS for color preparation

1. Capture with command `:EzbarColorCapture Constant`  
2. paste to buffer with `p`. here is result of my environment.  

```Vim
{'gui': ['', '#e5786d'], 'cterm': ['', '13']}
```

3. select that line edit and check color with `:EzbarColorCheck`  

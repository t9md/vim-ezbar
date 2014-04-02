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
![Mode](https://raw.github.com/t9md/t9md/master/img/ezbar/mode_insert.png)

* Change color when filename is XXX in this case begin with `tryit`
![Filename](https://raw.github.com/t9md/t9md/master/img/ezbar/filename_notify.png)

* Change color when git branch is not master  
![Git-1](https://raw.github.com/t9md/t9md/master/img/ezbar/git-branch_notify.png)

* Hide other statusline part when specific plugin active  
![Fill-1](https://raw.github.com/t9md/t9md/master/img/ezbar/ezbar_fill1.png)  
![Fill-2](https://raw.github.com/t9md/t9md/master/img/ezbar/ezbar_fill2.png)  

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

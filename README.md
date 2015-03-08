# What's this?
Advanced, customizable statusline plugin for minimalist.

# Feature

* Simple design, easy to configure for Vimscripter(advanced user).
* Easy to create color [theme](https://github.com/t9md/vim-ezbar/tree/master/autoload/ezbar/theme).
* Pluggable design for parts, theme.
* Change color dynamically based on condition(filename, git-branch etc).
* No precedence to predefined parts, so it's up to you how organize your statusline.

# Screen Capture

### Mode aware
![normal](https://raw.github.com/t9md/t9md/master/img/ezbar/neon-normal.png)
![insert](https://raw.github.com/t9md/t9md/master/img/ezbar/neon-insert.png)
![visual](https://raw.github.com/t9md/t9md/master/img/ezbar/neon-visual.png)

### Conditional color change

* Color `green` if buffer is `[quickrun output]`.
* Color `yellow` for filename begin with `tryit`.

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

* Color `red` when git-branch is not `master`.
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

Without any other configuration, ezbar use [default config](https://github.com/t9md/vim-ezbar/blob/master/autoload/ezbar/config/default.vim).

# Customize

Copy [default config](https://github.com/t9md/vim-ezbar/blob/master/autoload/ezbar/config/default.vim) to your configuration folder and source it from your `.vimrc`

```Vim
" for quick edit of ezbar config with <Space>e
nnoremap <Space>e  :<C-u>edit $EZBAR_CONFIG<CR>

let g:ezbar_enable  = 1
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
See [Advanced example](https://github.com/t9md/vim-ezbar/blob/master/misc/config_t9md.vim).

* Help
See `:help ezbar`

## TIPS for color preparation

1. Capture with command `:EzbarColorCapture Constant`  
2. paste to buffer with `p`. here is result of my environment.  

```Vim
{'gui': ['', '#e5786d'], 'cterm': ['', '13']}
```

3. select that line edit and check color with `:EzbarColorCheck`  

# Data structure of statusline representation?

Insall [thinca/vim-prettyprint](https://github.com/thinca/vim-prettyprint) and dump g:ezbar.

```vim
echo PP(g:ezbar)
```

Example output.
```vim
{
  '__loaded_default_config': 0,
  '__loaded_theme': 1,
  'active':
    '|1 fn |2 git wb s ro |3 tm cwd = |2 ft mod |1 enc % lc vd',
  'alias': {
    '%': 'percent',
    'enc': 'encoding',
    'ff': '_fileformat',
    'fn': '_filename',
    'ft': 'filetype',
    'git': 'fugitive',
    'lc': '_line_col',
    'm': 'mode',
    'mod': 'modified',
    'ro': 'readonly',
    's': 'smalls',
    'tm': 'textmanip',
    'vd': 'validate',
    'wb': 'win_buf',
    'wv': 'watch_var',
    '|i': '|inactive'
  },
  'color': {
    'SmallsCandidate': 'SmallsCandidate',
    'SmallsCurrent': 'SmallsCurrent',
    '_info': {'cterm': 35, 'gui': 'yellow'},
    '_pink': {'cterm': '15', 'gui': 'DeepPink'},
    '_warn': {'cterm': 9, 'gui': 'red'},
    'inactive': {
      'cterm': ['', '', 'reverse'],
      'gui': ['gray23', 'gray68']
    },
    'm_command': {'gui': ['#000000', '#54ae54']},
    'm_command_1': {'gui': ['#7ec27e', '#000000']},
    'm_command_2': {'gui': ['#1f1f1f', '#a9d6a9']},
    'm_command_3': {'gui': ['#000000', '#a9d6a9']},
    'm_insert': {'gui': ['#000000', '#00ff7f']},
    'm_insert_1': {'gui': ['#9aff9a', '#000000']},
    'm_insert_2': {'gui': ['#1f1f1f', '#00cd66']},
    'm_insert_3': {'gui': ['#000000', '#00cd66']},
    'm_normal': {'gui': ['#000000', '#ab82ff']},
    'm_normal_1': {'gui': ['#ab82ff', '#000000']},
    'm_normal_2': {'gui': ['#2f2f2f', '#ba55d3']},
    'm_normal_3': {'gui': ['#000000', '#ba55d3']},
    'm_other': {'gui': ['#000000', '#54ae54']},
    'm_other_1': {'gui': ['#7ec27e', '#000000']},
    'm_other_2': {'gui': ['#1f1f1f', '#a9d6a9']},
    'm_other_3': {'gui': ['#000000', '#a9d6a9']},
    'm_replace': {'gui': ['#000000', '#ff1493']},
    'm_replace_1': {'gui': ['#ff6eb4', '#000000']},
    'm_replace_2': {'gui': ['#1f1f1f', '#cd1076']},
    'm_replace_3': {'gui': ['#000000', '#cd1076']},
    'm_select': {'gui': ['#000000', '#54ae54']},
    'm_select_1': {'gui': ['#7ec27e', '#000000']},
    'm_select_2': {'gui': ['#1f1f1f', '#a9d6a9']},
    'm_select_3': {'gui': ['#000000', '#a9d6a9']},
    'm_visual': {'gui': ['#000000', '#ffb90f']},
    'm_visual_1': {'gui': ['#ffb90f', '#000000']},
    'm_visual_2': {'gui': ['#1f1f1f', '#ffd700']},
    'm_visual_3': {'gui': ['#000000', '#ffd700']},
    'warn':
      {'cterm': [9, 16], 'gui': ['OrangeRed2', 'AliceBlue']}
  },
  'hide_rule': {
    '35': ['readonly', 'cwd'],
    '50': ['percent'],
    '60': ['encoding', 'filetype', 'mode'],
    '65': ['fugitive', 'win_buf'],
    '90': ['cwd']
  },
  'inactive': '|i fn wb mod = ft enc',
  'parts': {
    '__': {
      '_color_change': function('192'),
      'bg': function('188'),
      'c': function('191'),
      'convert': function('195'),
      'fg': function('189'),
      'getvar': function('196'),
      'hide': function('193'),
      'invert_deco': function('187'),
      'merge': function('185'),
      'reverse': function('186'),
      's': function('190'),
      'screen': function('194')
    },
    '___separator': function('169'),
    '___setcolor': function('168'),
    '__active': 1,
    '__bufnr': 25,
    '__buftype': '',
    '__c': {'gui': ['#ab82ff', '#000000']},
    '__color': {
      'SmallsCandidate': 'SmallsCandidate',
      'SmallsCurrent': 'SmallsCurrent',
      '_info': {'cterm': 35, 'gui': 'yellow'},
      '_pink': {'cterm': '15', 'gui': 'DeepPink'},
      '_warn': {'cterm': 9, 'gui': 'red'},
      'inactive': {
        'cterm': ['', '', 'reverse'],
        'gui': ['gray23', 'gray68']
      },
      'm_command': {'gui': ['#000000', '#54ae54']},
      'm_command_1': {'gui': ['#7ec27e', '#000000']},
      'm_command_2': {'gui': ['#1f1f1f', '#a9d6a9']},
      'm_command_3': {'gui': ['#000000', '#a9d6a9']},
      'm_insert': {'gui': ['#000000', '#00ff7f']},
      'm_insert_1': {'gui': ['#9aff9a', '#000000']},
      'm_insert_2': {'gui': ['#1f1f1f', '#00cd66']},
      'm_insert_3': {'gui': ['#000000', '#00cd66']},
      'm_normal': {'gui': ['#000000', '#ab82ff']},
      'm_normal_1': {'gui': ['#ab82ff', '#000000']},
      'm_normal_2': {'gui': ['#2f2f2f', '#ba55d3']},
      'm_normal_3': {'gui': ['#000000', '#ba55d3']},
      'm_other': {'gui': ['#000000', '#54ae54']},
      'm_other_1': {'gui': ['#7ec27e', '#000000']},
      'm_other_2': {'gui': ['#1f1f1f', '#a9d6a9']},
      'm_other_3': {'gui': ['#000000', '#a9d6a9']},
      'm_replace': {'gui': ['#000000', '#ff1493']},
      'm_replace_1': {'gui': ['#ff6eb4', '#000000']},
      'm_replace_2': {'gui': ['#1f1f1f', '#cd1076']},
      'm_replace_3': {'gui': ['#000000', '#cd1076']},
      'm_select': {'gui': ['#000000', '#54ae54']},
      'm_select_1': {'gui': ['#7ec27e', '#000000']},
      'm_select_2': {'gui': ['#1f1f1f', '#a9d6a9']},
      'm_select_3': {'gui': ['#000000', '#a9d6a9']},
      'm_visual': {'gui': ['#000000', '#ffb90f']},
      'm_visual_1': {'gui': ['#ffb90f', '#000000']},
      'm_visual_2': {'gui': ['#1f1f1f', '#ffd700']},
      'm_visual_3': {'gui': ['#000000', '#ffd700']},
      'warn':
        {'cterm': [9, 16], 'gui': ['OrangeRed2', 'AliceBlue']}
    },
    '__filetype': 'vim',
    '__init': function('58'),
    '__layout': [
      '%#EzBar00025# •tryit.vim ',
      '%#EzBar00006#⮀',
      '%#EzBar00000# w:2 b:25 ',
      '%#EzBar00002#⮀',
      '%#EzBar00001# ~ ',
      '%#EzBar00001#%=',
      '%#EzBar00002#⮂',
      '%#EzBar00000# vim ',
      '%#EzBar00006#⮂',
      '%#EzBar00003# utf-8 ',
      '%#EzBar00003#⮃',
      '%#EzBar00003# %p%% ',
      '%#EzBar00003#⮃',
      '%#EzBar00003# ⭡ %l:%c:7 ',
      '%#EzBar00021#⮂',
      '%#EzBar00020# Ξ23 '
    ],
    '__loaded_special_parts': 1,
    '__mode': 'n',
    '__part_missing': function('59'),
    '__parts': {
      '___separator::': {
        '__section_color':
          {'gui': ['#000000', '#ba55d3']},
        'c': {'gui': ['#000000', '#ba55d3']},
        'color_name': 'EzBar00001',
        'name': '___separator::',
        's': '%='
      },
      '_filename': {
        '__section_color':
          {'gui': ['#ab82ff', '#000000']},
        'c': {'gui': ['#ab82ff', 'yellow']},
        'color_name': 'EzBar00025',
        'name': '_filename',
        's': ' •tryit.vim '
      },
      '_line_col': {
        '__section_color':
          {'gui': ['#ab82ff', '#000000']},
        'c': {'gui': ['#ab82ff', '#000000']},
        'color_name': 'EzBar00003',
        'name': '_line_col',
        's': ' ⭡ %l:%c:7 '
      },
      'cwd': {
        '__section_color': {'gui': ['#000000', '#ba55d3']},
        'c': {'gui': ['#000000', '#ba55d3']},
        'color_name': 'EzBar00001',
        'name': 'cwd',
        's': ' ~ '
      },
      'encoding': {
        '__section_color':
          {'gui': ['#ab82ff', '#000000']},
        'c': {'gui': ['#ab82ff', '#000000']},
        'color_name': 'EzBar00003',
        'name': 'encoding',
        's': ' utf-8 '
      },
      'filetype': {
        '__section_color':
          {'gui': ['#2f2f2f', '#ba55d3']},
        'c': {'gui': ['#2f2f2f', '#ba55d3']},
        'color_name': 'EzBar00000',
        'name': 'filetype',
        's': ' vim '
      },
      'percent': {
        '__section_color': {'gui': ['#ab82ff', '#000000']},
        'c': {'gui': ['#ab82ff', '#000000']},
        'color_name': 'EzBar00003',
        'name': 'percent',
        's': ' %p%% '
      },
      'validate': {
        '__section_color':
          {'gui': ['#ab82ff', '#000000']},
        'c':
          {'cterm': [9, 16], 'gui': ['OrangeRed2', 'AliceBlue']},
        'color_name': 'EzBar00020',
        'name': 'validate',
        's': ' Ξ23 '
      },
      'win_buf': {
        '__section_color': {'gui': ['#2f2f2f', '#ba55d3']},
        'c': {'gui': ['#2f2f2f', '#ba55d3']},
        'color_name': 'EzBar00000',
        'name': 'win_buf',
        's': ' w:2 b:25 '
      }
    },
    '__width': 104,
    '__winnr': 2,
    '_fileformat': function('41'),
    '_filename': function('45'),
    '_line_col': function('44'),
    'asis': function('43'),
    'cfi': function('42'),
    'choosewin': function('48'),
    'cwd': function('53'),
    'encoding': function('34'),
    'fileformat': function('35'),
    'filename': function('37'),
    'filetype': function('36'),
    'fugitive': function('55'),
    'line_col': function('32'),
    'mixed_indent': function('51'),
    'mode': function('28'),
    'modified': function('30'),
    'percent': function('29'),
    'readonly': function('40'),
    'smalls': function('54'),
    'textmanip': function('52'),
    'trailingWS': function('50'),
    'unite_buffer_name': function('56'),
    'unite_status': function('57'),
    'validate': function('49'),
    'watch_var': function('47'),
    'win_buf': function('39'),
    'winwidth': function('46')
  },
  'separator_L': '⮁',
  'separator_R': '⮃',
  'separator_border_L': '⮀',
  'separator_border_R': '⮂',
  'sym': {
    'EOL': '↩',
    'branch': '⭠',
    'indent': '≫',
    'line': '⭡',
    'lock': '⭤',
    'notify': '•',
    'trail': 'Ξ'
  },
  'theme': 'neon'
}
```

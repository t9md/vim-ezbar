let g:ezbar_enable = 1
let s:bg = 'gray25'
let g:ezbar = {}
let g:ezbar.active = [
      \ { 'chg_color': {'gui': [ s:bg, 'gray61'], 'cterm': [240, 254] }},
      \ 'mode',
      \ 'textmanip',
      \ 'readonly',
      \ 'filename',
      \ 'smalls',
      \ 'modified',
      \ 'filetype',
      \ 'fugitive',
      \ { '__SEP__': {'gui': [ 'gray22', 'gray61'],'cterm':[238, 254] }},
      \ 'cwd',
      \ 'encoding',
      \ 'percent',
      \ 'line_col',
      \ 'choosewin',
      \ ]
let g:ezbar.inactive = [
      \ { 'chg_color': {'gui':[ 'gray22', 'gray57' ], 'cterm': [238, 254] }},
      \ 'modified',
      \ 'filetype',
      \ 'filename',
      \ { '__SEP__': { 'gui': [ 'gray23', 'gray61'], 'cterm': [240, 254] }},
      \ 'encoding',
      \ 'choosewin',
      \ ]

let s:u = {}
function! s:u.textmanip(_) "{{{3
  if !exists('g:textmanip_current_mode') | return '' | endif
  let s = toupper(g:textmanip_current_mode[0])
  return { 's' : s, 'c': s == 'R'
        \ ?  {'gui':['DeepPink', 'ivory3'], 'cterm':[ 13, 15] }
        \ :  {'gui':[ s:bg, 'PaleGreen1'],  'cterm':[ '', 10] }
        \ }
endfunction

function! s:u.cwd(_) "{{{3
  let cwd = substitute(getcwd(), expand($HOME), '~', '')
  let cwd = substitute(cwd, '\V~/.vim/bundle/', '[vim-b]', '')
  let cwd = cwd[-10:-1]
  if winwidth(0) < 58
    let cwd = ''
  endif
  return cwd
endfunction

function! s:u.smalls(_) "{{{3
  if !exists('g:smalls_current_mode') | return '' | endif
  let s = g:smalls_current_mode
  if empty(s)
    return ''
  endif
  let self.__smalls_active = 1
  let color = s == 'excursion' ? 'SmallsCurrent' : 'SmallsCandidate'
  return { 's': s, 'c': color }
endfunction

function! s:u.choosewin(_) "{{{3
  if !exists('g:choosewin_active') | return '' | endif
  if !g:choosewin_active
    return
  endif
  return {
        \ 's': '    '. a:_ . '    ',
        \ 'c': { 'gui': ['ForestGreen', 'white', 'bold'], 'cterm': [ 9, 16] },
        \ }
endfunction

function! s:u.fugitive(_) "{{{3
  let s = fugitive#head()
  return { 's': s, 'c': s !=# 'master'
        \ ? {'gui': ['OrangeRed2', 'AliceBlue' ], 'cterm': [9, 15]} : ''  }
endfunction

function! s:u._filter(layout, parts) "{{{3
  if self.__smalls_active && self.__is_active
    return filter(a:layout, 'v:val.name == "smalls"')
  endif

  if exists('g:choosewin_active') && g:choosewin_active
    return filter(a:layout, 'v:val.name =~ "choosewin\\|__SEP__"')
  endif

  if self.__is_active
        \ && has_key(a:parts, 'filename')
        \ && a:parts.filename.s =~# 'tryit\.'

    let a:parts.filename.c.gui = ["ForestGreen", "white", "bold"]
  endif
  return a:layout
endfunction

function! s:u._init() "{{{3
  let self.__smalls_active = 0
endfunction "}}}

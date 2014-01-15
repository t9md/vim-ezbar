" Base:
let g:ezbar             = {}
let g:ezbar.separator_L = '|'
let g:ezbar.separator_R = '|'
let g:ezbar.color = {
      \ 'warn':       {'gui': ['OrangeRed2', 'AliceBlue'], 'cterm' :[ 9, 16] },
      \ 'm_normal':   {'gui': ['SkyBlue3',      'gray14'], 'cterm': [33, 16] },
      \ 'm_insert':   {'gui': ['PaleGreen3',    'gray14'], 'cterm': [10, 16] },
      \ 'm_replace':  {'gui': ['tomato1',       'gray14'], 'cterm': [ 1, 16] },
      \ 'm_visual':   {'gui': ['PaleVioletRed', 'gray14'], 'cterm': [ 9, 16] },
      \ 'm_other':    {'gui': ['cyan1',         'gray14'], 'cterm': [ 9, 16] },
      \ 'statusline': {'gui': ['gray23',        'gray68'], 'cterm': ['', ''] },
      \ }

" Layout:
 " {{{
let g:ezbar.active = [
      \ 'mode',
      \ '--- mode_rev',
      \ 'win_buf',
      \ 'textmanip',
      \ 'smalls',
      \ 'fugitive',
      \ 'cwd',
      \ '===',
      \ 'readonly',
      \ '--- mode_rev2',
      \ 'filename',
      \ 'modified',
      \ '--- mode',
      \ 'filetype',
      \ 'encoding',
      \ 'percent',
      \ 'line_col',
      \ 'validate',
      \ ]
      " \ 'choosewin',
let g:ezbar.inactive = [
      \ '--- statusline',
      \ 'win_buf',
      \ 'modified',
      \ '===',
      \ 'filename',
      \ 'filetype',
      \ 'encoding',
      \ ]
      " \ 'choosewin',
 " }}}

let s:features = ['readonly', 'filename', 'modified', 'filetype', 'encoding', 'percent', 'line_col' ]
let s:u = ezbar#parts#default#use(s:features)
unlet s:features

" ModeMap:
" {{{1
let s:mode_map = {
      \ 'n':      { 's': 'N ', 'c': g:ezbar.color['m_normal']  },
      \ 'i':      { 's': 'I ', 'c': g:ezbar.color['m_insert']  },
      \ 'R':      { 's': 'R ', 'c': g:ezbar.color['m_replace'] },
      \ 'v':      { 's': 'V ', 'c': g:ezbar.color['m_visual']  },
      \ 'V':      { 's': 'VL', 'c': g:ezbar.color['m_visual']  },
      \ "\<C-v>": { 's': 'VB', 'c': g:ezbar.color['m_visual']  },
      \ 'c':      { 's': 'C ', 'c': g:ezbar.color['m_other']   },
      \ 's':      { 's': 'S ', 'c': g:ezbar.color['m_other']   },
      \ 'S':      { 's': 'SL', 'c': g:ezbar.color['m_other']   },
      \ "\<C-s>": { 's': 'SB', 'c': g:ezbar.color['m_other']   },
      \ '?':      { 's': '  ', 'c': g:ezbar.color['m_other']   },
      \ }
"}}}

function! s:u.mode(_) "{{{1
  let mode = mode()
  let R = get(s:mode_map, mode, mode)
  let mode_rev = self.__.reverse(R.c)
  call extend(self.color, {
        \ 'mode': R.c,
        \ 'mode_rev': mode_rev,
        \ 'mode_rev2': self.__.bg(mode_rev, {'gui': 'gray25', 'cterm':'gray'})
        \ })
  return R
endfunction

function! s:u.cfi(_) "{{{1
  if exists('*cfi#format')
    return { 's': cfi#format('%.43s()', '') }
  end
  return ''
endfunction

function! s:u.variable(_) "{{{1
  if exists('g:V')
    return string(g:V)
  endif
endfunction

function! s:u.choosewin(_) "{{{1
  let label = ' ' . g:choosewin_label[a:_ - 1] . ' '
  return {
        \ 's': label,
        \ 'ac': { 'gui': ['LimeGreen', 'black', 'bold'], 'cterm': [ 40, 16, 'bold'] },
        \ 'ic': { 'gui': ['DarkGreen', 'white', 'bold'], 'cterm': [ 22, 15,'bold'] },
        \ }
endfunction

function! s:u.validate(_) "{{{1
  for F in [ self.trailingWS, self.mixed_indent ]
    let R = call(F, [a:_] , self)
    if !empty(R)
      return R
    endif
    unlet R
  endfor
endfunction

function! s:u.trailingWS(_) "{{{1
  if get(g:, 'choosewin_active', 0)
    return ''
  endif
  if !empty(getwinvar(a:_, '&buftype'))
    return ''
  endif
  let filetype = getwinvar(a:_, '&filetype')
  if index(s:trailingWS_exclude_filetype, filetype) !=# -1
    return ''
  endif
  let line = search(' $', 'nw')
  if !empty(line)
    return { 's': 'trail: ' . line, 'c': self.color.warn }
  endif
endfunction
let s:trailingWS_exclude_filetype = ['unite', 'markdown']

function! s:u.mixed_indent(_) "{{{1
  if getwinvar(a:_, '&ft') == 'help'
    return
  endif
  let indents = [
        \ search('^ \{2,}', 'nb'),
        \ search('^ \{2,}', 'n'),
        \ search('^\t', 'nb'),
        \ search('^\t', 'n')
        \ ]
  let mixed = indents[0] != 0 && indents[1] != 0 && indents[2] != 0 && indents[3] != 0
  if mixed
    let mixnr = indents[0] == indents[1] ? indents[0] : indents[2]
    return { 's': 'indent: ' . mixnr, 'c': self.color.warn }
  endif
endfunction

function! s:u.winnr(_) "{{{1
  return printf('w:%d', a:_)
endfunction

function! s:u.win_buf(_) "{{{1
  return printf('w:%d b:%d', a:_, self.bufnr(a:_))
endfunction

function! s:u.bufnr(_) "{{{1
  return printf('b:%d', winbufnr(a:_))
endfunction

function! s:u.textmanip(_) "{{{1
  if !exists('g:textmanip_current_mode') | return '' | endif
  let s = g:textmanip_current_mode[0]
  if s !=# 'r'
    return
  endif
  return { 's' : '[R]', 'c': {'gui':['', 'DeepPink'], 'cterm':[ 13, 15] } }
endfunction

function! s:u.cwd(_) "{{{1
  let cwd = substitute(getcwd(), expand($HOME), '~', '')
  let cwd = substitute(cwd, '\V~/.vim/bundle/', '[bdl]', '')
  let display =
        \ self.winwidth < 90 ? -15 :
        \ self.winwidth < 45 ? -10 : 0
  return cwd[ display :  -1 ]
endfunction

function! s:u.smalls(_) "{{{1
  if !exists('g:smalls_current_mode') | return '' | endif
  let s = g:smalls_current_mode
  if empty(s)
    return ''
  endif
  let color = s == 'exc' ? 'SmallsCurrent' : 'SmallsCandidate'
  return { 's': s, 'c': color }
endfunction

function! s:u.fugitive(_) "{{{1
  if winwidth(a:_) < 60
    return
  endif
  let s = fugitive#head()
  if s ==# 'master'
    return s
  endif
  return { 's': s, 'c':
        \ self.__.fg(self.__color, {'gui': 'red', 'cterm': 'red' }),
        \ }
endfunction

function! s:u._init(_) "{{{1
  let self.color = g:ezbar.color
  let self.winwidth = winwidth(a:_)
  let hide = []
  if winwidth(a:_) < 90
    " let hide += ['cwd']
  endif
  if winwidth(a:_) < 70
    let hide += ['encoding', 'percent', 'filetype']
  endif
  call filter(self.__layout, 'index(hide, v:val) ==# -1')
endfunction


function! s:u._finish() "{{{1
  let PARTS = self.__parts
  " if has_key(self.__parts, 'smalls')
    " let self.__layout = [self.__parts.smalls]
  " endif
  if self.__.s('filename') =~# 'tryit\.'
    let PARTS.filename.c = self.__.fg(PARTS.filename.c,
          \ {'gui': 'yellow', 'cterm': 'yellow'})
  endif
endfunction

function! s:u._parts_missing(_, part) "{{{1

endfunction
"}}}

let g:ezbar.parts = s:u
unlet s:u
" vim: foldmethod=marker

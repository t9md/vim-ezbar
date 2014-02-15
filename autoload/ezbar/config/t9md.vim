" Surely not work as-is in your environment.
" Since this is my specific configuration

" The purpose for this file put here is show you
" how you can
"
" - customize color within parts
" - how to use hook
"
"
let g:ezbar = {}
let g:ezbar.theme = 'default'
let g:ezbar.color = {
      \ '_warn': { 'gui': 'red',      'cterm': 9    },
      \ '_info': { 'gui': 'yellow',   'cterm': 35   },
      \ '_pink': { 'gui': 'DeepPink', 'cterm': '15' },
      \ 'SmallsCurrent':   'SmallsCurrent',
      \ 'SmallsCandidate': 'SmallsCandidate',
      \ }

" in font I use
" 2b60 ⭠
" 2b61 ⭡
" 2b62 ⭢
" 2b63 ⭣
" 2b64 ⭤
" 2b80 ⮀
" 2b81 ⮁
" 2b82 ⮂
" 2b83 ⮃

let g:ezbar.symbols = {
      \ 'EOL':          "\U21A9",
      \ 'branch':       "\U2b60",
      \ 'line':         "\U2b61",
      \ 'filetype1':    "\U2b62",
      \ 'filetype2':    "\U2b63",
      \ 'lock':         "\U2b64",
      \ 'arrow_hard_R': "\U2b80",
      \ 'arrow_soft_R': "\U2b81",
      \ 'arrow_hard_L': "\U2b82",
      \ 'arrow_soft_L': "\U2b83",
      \ }
let g:ezbar.sym = g:ezbar.symbols
let g:ezbar.separator_L        = g:ezbar.symbols.arrow_soft_R
let g:ezbar.separator_R        = g:ezbar.symbols.arrow_soft_L
let g:ezbar.separator_border_L = g:ezbar.symbols.arrow_hard_R
let g:ezbar.separator_border_R = g:ezbar.symbols.arrow_hard_L

let g:ezbar.alias = {
      \ 'm':   'mode',
      \ 'git': 'fugitive',
      \ 's':   'smalls',
      \ 'ro':  'readonly',
      \ 'fn':  '_filename',
      \ 'tm':  'textmanip',
      \ 'mod': 'modified',
      \ 'ft':  'filetype',
      \ 'ff':  '_fileformat',
      \ 'wb':  'win_buf',
      \ 'enc': 'encoding',
      \ '%':   'percent',
      \ 'lc':  '_line_col',
      \ 'vd':  'validate',
      \ '|i':  '|inactive',
      \ }
let g:ezbar.hide_rule = {
      \ 90: ['cwd'],
      \ 65: ['fugitive'],
      \ 60: ['encoding', 'filetype'],
      \ 50: ['percent'],
      \ 35: ['mode', 'readonly', 'cwd'],
      \ }
 " Layout:
let g:ezbar.active
      \ = '|1 m |2 git wb s ro |3 tm cwd = |2 fn ft mod |1 enc % lc vd'
let g:ezbar.inactive
      \ = '|i wb mod = fn ft enc'

let s:features = [
      \ 'mode', 'filename', 'modified', 'filetype', 'win_buf', 'fileformat',
      \ 'encoding', 'percent', 'line_col' ]
let s:u = ezbar#parts#use('default', {'parts': s:features })
unlet s:features

function! s:u.readonly() "{{{1
  return getwinvar(self.__winnr, '&readonly') ? g:ezbar.sym.lock : ''
endfunction

function! s:u._fileformat() "{{{1
  return self.fileformat() . g:ezbar.sym.EOL
endfunction

function! s:u.cfi() "{{{1
  if exists('*cfi#format')
    return { 's': cfi#format('%.43s()', '') }
  end
  return ''
endfunction

function! s:u.asis(...) "{{{1
  return join(a:000, '|')
endfunction

function! s:u._line_col() "{{{1
  return g:ezbar.sym.line . ' ' . self.line_col() . ':' . col('$')
endfunction

function! s:u._filename() "{{{1
  let s = self.filename()
  let notify_sym = "\U2022"
  if s =~# 'tryit\.\|default\.vim\|phrase__'
    return {
          \ 's' : notify_sym . s,
          \ 'c'  : self.__.fg(self.__color._info) }
  else
    return s
  endif
endfunction

function! s:u.winwidth() "{{{1
  return self.__width
endfunction

function! s:u.watch_var() "{{{1
  try
    return string(get(w:, 'zoom', ''))
  catch
    return ''
  endtry
endfunction

function! s:u.choosewin() "{{{1
  return g:choosewin_label[self.__winnr - 1]
endfunction

function! s:u.validate() "{{{1
  for funcname in [ 'trailingWS', 'mixed_indent' ]
    let R = self[funcname]()
    if !empty(R)
      return { 's': R, 'c': self.__color.warn }
    endif
    unlet R
  endfor
  return ''
endfunction

function! s:u.trailingWS() "{{{1
  if self.__buftype isnot# '' || self.__mode isnot# 'n'
    return ''
  endif
  if index(s:trailingWS_exclude_filetype, self.__filetype) !=# -1
    return ''
  endif
  let line = search(' $', 'nw')
  if !empty(line)
    let trail_symbol = 'Ξ'
    return trail_symbol . line
  endif
endfunction
let s:trailingWS_exclude_filetype = ['unite', 'markdown']

function! s:u.mixed_indent() "{{{1
  if self.__filetype == 'help'
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
    let indent_symbol = "\U226B"
    return indent_symbol . mixnr
  endif
endfunction

function! s:u.textmanip() "{{{1
  if !exists('g:textmanip_current_mode') | return '' | endif
  return g:textmanip_current_mode[0] is 'r'
        \ ? { 's' : 'R', 'c': self.__.fg(self.__color._pink) }
        \ : ''
endfunction

function! s:u.cwd() "{{{1
  let cwd = substitute(getcwd(), expand($HOME), '~', '')
  let cwd = substitute(cwd, '\V~/.vim/bundle/', '[Bundle] ', '')
  let display =
        \ self.__width < 90 ? -15 :
        \ self.__width < 45 ? -10 : -5
  return cwd[ display :  -1 ]
endfunction

function! s:u.smalls() "{{{1
  if !exists('g:smalls_current_mode') | return '' | endif
  let s = g:smalls_current_mode
  if empty(s) | return '' | endif
  return { 's': s,
        \ 'c':  ( s is 'exc') ? 'SmallsCurrent' : 'SmallsCandidate' }
endfunction

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

function! s:u.hide(hide_list) "{{{1
  let hide_list = copy(a:hide_list)
  for [ limit, parts ] in items(g:ezbar.hide_rule)
    if self.__width < str2nr(limit)
      let hide_list += parts
    endif
  endfor
  call filter(self.__layout, 'index(hide_list, v:val) ==# -1')
endfunction

function! s:u.__init() "{{{1
  if !self.__active
    return
  endif
  let hide = []
  if get(g:, 'choosewin_active', 0)
    let hide += ['validate']
  endif
  call self.__.hide(hide)
endfunction

function! s:u.__part_missing(part, ...) "{{{1
  return join(a:000, '-')
endfunction
"}}}

let g:ezbar.parts = s:u
unlet s:u
" vim: foldmethod=marker

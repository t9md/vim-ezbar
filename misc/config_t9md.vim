" Surely not work as-is in your environment.
" Since this is my specific configuration

" The purpose for this file put here is how you how you can
"
"   - customize color within parts
"   - how to use hook
"

let g:ezbar_enable_default_config = 0
let g:ezbar = {}
let g:ezbar.theme = has('gui_running') ? 'neon' : 'neon3'
" let g:ezbar.theme = 'fancy'
" let g:ezbar.theme = 'neon3'

let s:features = [
      \ 'mode', 'filename', 'modified', 'filetype', 'win_buf', 'fileformat',
      \ 'encoding', 'percent', 'line_col' ]
let s:parts = ezbar#parts#use('default', {'parts': s:features })
unlet s:features

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
      \ 'wv':  'watch_var',
      \ '|i':  '|inactive',
      \ }

let g:ezbar.active   = '|1 fn |2 git wb s ro |3 tm cwd = |2 ft mod |1 enc % lc vd'
let g:ezbar.inactive = '|i fn wb mod = ft enc'

let g:ezbar.hide_rule = {
      \ 90: ['cwd'],
      \ 65: ['fugitive', 'win_buf'],
      \ 60: ['encoding', 'filetype', 'mode'],
      \ 50: ['percent'],
      \ 35: ['readonly', 'cwd'],
      \ }

let g:ezbar.color = {
      \ '_warn': { 'gui': 'red',      'cterm': 9    },
      \ '_info': { 'gui': 'yellow',   'cterm': 35   },
      \ '_pink': { 'gui': 'DeepPink', 'cterm': '15' },
      \ 'warn':  {'gui': ['#000000', '#ff0000'], 'cterm': [ 0, 196 ] },
      \ 'SmallsCurrent':   'SmallsCurrent',
      \ 'SmallsCandidate': 'SmallsCandidate',
      \ }

" Font I use
" ---------------------
" trail      \U039E  Ξ
" notify     \U2022  •
" EOL        \U21A9  ↩
" indent     \U226B  ≫
" line       \U2B61  ⭡
" lock       \U2B64  ⭤
" branch     \U2B60  ⭠

" 2b80 ⮀
" 2b81 ⮁
" 2b82 ⮂
" 2b83 ⮃

let g:ezbar.sym = {
      \ 'EOL':          "\U21A9",
      \ 'branch':       "\U2b60",
      \ 'line':         "\U2b61",
      \ 'lock':         "\U2b64",
      \ 'notify':       "\U2022",
      \ 'indent':       "\U226B",
      \ 'trail':        "\U039E",
      \ }

let g:ezbar.separator_L        = "\U2b81"
let g:ezbar.separator_border_L = "\U2b80"
let g:ezbar.separator_R        = "\U2b83"
let g:ezbar.separator_border_R = "\U2b82"

function! s:parts.readonly() "{{{1
  return getwinvar(self.__winnr, '&readonly') ? g:ezbar.sym.lock : ''
endfunction

function! s:parts._fileformat() "{{{1
  return self.fileformat() . g:ezbar.sym.EOL
endfunction

function! s:parts.cfi() "{{{1
  if exists('*cfi#format')
    return { 's': cfi#format('%.43s()', '') }
  end
  return ''
endfunction

function! s:parts.asis(...) "{{{1
  return join(a:000, '|')
endfunction

function! s:parts._line_col() "{{{1
  return g:ezbar.sym.line . ' ' . self.line_col() . ':' . col('$')
endfunction

function! s:parts._filename() "{{{1
  let s = self.filename()
  if !self.__active && s =~# '\[quickrun output\]'
    return {
          \ 's' : s,
          \ 'c'  : self.__color.m_insert }
  endif

  if s =~# 'tryit\.\|default\.vim\|phrase__'
    return {
          \ 's' : g:ezbar.sym.notify . s,
          \ 'c'  : self.__.fg(self.__color._info) }
  else
    return s
  endif
endfunction

function! s:parts.winwidth() "{{{1
  return self.__width
endfunction

function! s:parts.watch_var() "{{{1
  try
    " return string(get(g:, 'choosewin_win_prev', ''))
    return string(choosewin#get_previous())
  catch
    return ''
  endtry
endfunction

function! s:parts.choosewin() "{{{1
  return g:choosewin_label[self.__winnr - 1]
endfunction

function! s:parts.validate() "{{{1
  for funcname in [ 'trailingWS', 'mixed_indent' ]
    let R = self[funcname]()
    if !empty(R)
      return { 's': R, 'c': self.__color.warn }
    endif
    unlet R
  endfor
  return ''
endfunction

function! s:parts.trailingWS() "{{{1
  if self.__buftype isnot# '' || self.__mode isnot# 'n'
    return ''
  endif
  if index(s:trailingWS_exclude_filetype, self.__filetype) !=# -1
    return ''
  endif
  let line = search(' $', 'nw')
  if !empty(line)
    return g:ezbar.sym.trail . line
  endif
endfunction
let s:trailingWS_exclude_filetype = ['unite', 'markdown']

function! s:parts.mixed_indent() "{{{1
  if self.__filetype =~ 'help\|go'
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
    return g:ezbar.sym.indent . mixnr
  endif
endfunction

function! s:parts.textmanip() "{{{1
  if !exists('g:textmanip_current_mode') | return '' | endif
  return g:textmanip_current_mode[0] is 'r'
        \ ? { 's' : 'R', 'c': self.__.fg(self.__color._pink) }
        \ : ''
endfunction

function! s:parts.cwd() "{{{1
  let cwd = substitute(getcwd(), expand($HOME), '~', '')
  let cwd = substitute(cwd, '\V~/.vim/bundle/', 'BDL:', '')
  let display =
        \ self.__width < 90 ? -15 :
        \ self.__width < 45 ? -10 : 0
  return cwd[ display :  -1 ]
endfunction

function! s:parts.smalls() "{{{1
  if !exists('g:smalls_current_mode') | return '' | endif
  let s = g:smalls_current_mode
  if empty(s) | return '' | endif
  return { 's': s,
        \ 'c':  ( s is 'exc') ? 'SmallsCurrent' : 'SmallsCandidate' }
endfunction

function! s:parts.fugitive() "{{{1
  let s = fugitive#head()
  if s is '' | return '' | endif
  let branch_symbol = g:ezbar.sym.branch . ' '
  if s ==# 'master'
    return { 's': branch_symbol . s }
  else
    return { 's': branch_symbol . s, 'c': self.__.fg(self.__color._warn) }
  endif
endfunction


function! s:parts.unite_buffer_name() "{{{1
  return '%{b:unite.buffer_name}'
endfunction

function! s:parts.unite_status() "{{{1
  return '%{unite#get_status_string()}'
endfunction

function! s:parts.__init() "{{{1
  if !self.__active
    return
  endif
  if self.__filetype is# 'unite'
    let self.__layout = '|1 asis::Unite |2 unite_buffer_name |2 unite_status'
    return
  endif

  let hide = []
  if get(g:, 'choosewin_active', 0)
    " Avoid validate while choosewin_active,
    "  since choosewin overlay temporarily add trailing white space.
    let hide += ['validate']
  endif
  call self.__.hide(hide)
endfunction

function! s:parts.__part_missing(part, ...) "{{{1
  " called when corresponding part func was missing.
  return join(a:000, '-')
endfunction
"}}}

let g:ezbar.parts = s:parts
unlet s:parts

" vim: foldmethod=marker

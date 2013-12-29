" Advanced Example:
" This is the example to show power of ezbar's feature.
" As the example, following feature is implemented by user's config not by plugin
" itself.
"     - ColorTheme
"     - Readable String representation of statusline layout.
"     active = '| mode  part1 part1 | part2 =|= part3 part3 | part4 part4'

" ezbar のカスタマイズの可能性を説明するためのサンプル.
" サンプルとして、以下の実装を紹介する。これらは ezbar
" のコアの機能側ではなく、ユーザーの設定として実装している。
"     - カラー・テーマ
"     - 以下の様な可読性の高い文字列でレイアウトを設定する。
"     active = '| mode  part1 part1 | part2 =|= part3 part3 | part4 part4'

" ColorTheme: {{{1
let s:color_theme_A = {
      \   'active': [
      \     {'gui': [ 'AntiqueWhite1', 'black'] },
      \     {'gui': [ 'AntiqueWhite2', 'black'] },
      \     {'gui': [ 'AntiqueWhite3', 'black'] },
      \     {'gui': [ 'AntiqueWhite4', 'black'] },
      \   ],
      \   'inactive': [
      \     {'gui': [ 'NavajoWhite1', 'black'] },
      \     {'gui': [ 'NavajoWhite2', 'black'] },
      \     {'gui': [ 'NavajoWhite3', 'black'] },
      \     {'gui': [ 'NavajoWhite4', 'black'] },
      \   ],
      \ }

let s:color_theme_B = {
      \   'active': [
      \     {'gui': [ 'LightSalmon', 'black'] },
      \     {'gui': [ 'orange',      'black'] },
      \     {'gui': [ 'DarkOrange',  'black'] },
      \     {'gui': [ 'coral',       'black'] },
      \   ],
      \   'inactive': [
      \     {'gui': [ 'goldenrod',     'black'] },
      \     {'gui': [ 'DarkGoldenrod', 'black'] },
      \     {'gui': [ 'SaddleBrown',   'black'] },
      \     {'gui': [ 'sienna',        'black'] },
      \   ],
      \ }
"}}}

let g:ezbar = {}
let g:ezbar_enable = 1
let g:ezbar.color_theme = s:color_theme_A
" let g:ezbar.color_theme = s:color_theme_B

" Readable Way:
" =|=: separator
" |:   change color( pick color from color_theme )
let s:active   = '| mode  part1 part1 | part2 =|= part3 part3 | part4 part4'
let s:inactive = '| part1 part1       | part2 =|= part3       | part4      '
let g:ezbar.active   = split(s:active)
let g:ezbar.inactive = split(s:inactive)
unlet s:active
unlet s:inactive

" Vertical: {{{1
" let g:ezbar.active = [
"       \ '----',
"       \ 'mode',
"       \ 'part1',
"       \ 'part1',
"       \ '----',
"       \ 'part2',
"       \ '====',
"       \ 'part3',
"       \ 'part3',
"       \ '----',
"       \ 'part4',
"       \ 'part4',
"       \ ]
" 
" let g:ezbar.inactive = [
"       \ '----',
"       \ 'part1',
"       \ 'part1',
"       \ '----',
"       \ 'part2',
"       \ '====',
"       \ 'part3',
"       \ '----',
"       \ 'part4',
"       \ ]
" }}}

let s:u = {}
function! s:u.part1(_)
  return 'part1'
endfunction
function! s:u.part2(_)
  return 'part2'
endfunction
function! s:u.part3(_)
  return 'part3'
endfunction
function! s:u.part4(_)
  return 'part4'
endfunction

function! s:u.__SEP(_)
  " separator
  " セパレータ
  call self.__CHANGE_COLOR(a:_)
  return '%='
endfunction

function! s:u._init(_)
  let self.__color_index = 0
endfunction "}}}

function! s:u.__CHANGE_COLOR(_)
  " each call pop next color from .color_theme
  " 呼ばれる度に、.color_theme から次の色を選んで、デフォルト色に設定する。
  let self.__default_color = self.__is_active
        \ ? g:ezbar.color_theme.active[self.__color_index]
        \ : g:ezbar.color_theme.inactive[self.__color_index]
  let self.__color_index += 1
  return
endfunction

" Fix Cosmetic:
let s:u['='] = s:u.__SEP
let s:u['=='] = s:u.__SEP
let s:u['==='] = s:u.__SEP
let s:u['===='] = s:u.__SEP
let s:u['=|='] = s:u.__SEP

let s:u['|'] = s:u.__CHANGE_COLOR
let s:u['-'] = s:u.__CHANGE_COLOR
let s:u['--'] = s:u.__CHANGE_COLOR
let s:u['---'] = s:u.__CHANGE_COLOR
let s:u['----'] = s:u.__CHANGE_COLOR

let g:ezbar.parts = extend(ezbar#parts#default#new(), s:u)
unlet s:u
